require 'bindata'
require 'newfor_gem/hamming'
require 'newfor_gem/character_sets'

module NewforGem
  class Newfor < BinData::Record

  # default language = English
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # subtitle package structure
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    uint8 :package_type
    uint8 :package_info, :onlyif => :build?
    array :packet, :initial_length => :number_of_rows, :onlyif => :build? do
      uint8 :address0
      uint8 :address1
      uint8 :not_used, :onlyif => lambda { address1 == 12 }
      array :x26, :initial_length => 13, :onlyif => lambda { address1 == 12 } do
        uint8 :data0
        uint8 :data1
        uint8 :data2
      end
      array :text, :initial_length => 40, :onlyif => lambda { address1 != 12 } do
        uint8 :col
      end
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    def build?
      package_type == 0x0f
    end

    def number_of_rows
      UNHAM_8_4[package_info] & 0x07
    end

    def col_stop(row)
      chr = row.index(0x0a)
      chr ? chr - 1 : 39
    end

    def col_start(row)
      row.rindex(0x0b) + 1
    end

    def x26?(packet)
      packet.address1 == 12
    end

    def timestamp
      Time.now.to_f
    end

    def lang_to_iso(lang)
      case lang
        when /IT/
          IT
        when /FR/
          FR
        when /DE/
          DE
        when /SW/
          SW
        when /ES|PT/
          ES
        else # Default to English
          EN
      end
    end

    def unham_24_18(a)
      b0 = a & 0xff
      b1 = (a >> 8) & 0xff
      b2 = (a >> 16) & 0xff
    
      d1_d4 = UNHAM_24_18_D1_D4[b0 >> 2]
      d5_d11 = b1 & 0x7f
      b12_d18 = b2 & 0x7f
    
      d = d1_d4 | d5_d11 << 4 | b12_d18 << 11
      abcdef = UNHAM_24_18_PAR[0][b0] ^ UNHAM_24_18_PAR[1][b1] ^ UNHAM_24_18_PAR[2][b2]
      d ^ UNHAM_24_18_ERR[abcdef]
    end

    def unham_8_4(a)
      UNHAM_8_4[a] & 0x0f
    end

    def row_address(p)
      address = (unham_8_4(p.address1) << 4) | unham_8_4(p.address0)
      (address >> 3) & 0x1f
    end

    def map_row_address_to_array(r)
      @utf8_packet.each_index do |i|
        return i if @utf8_packet[i][:bloffset] == BL_OFFSET[r]
      end
      nil
    end

    def packet_to_utf8(iso)
      @utf8_packet = []


      packet.each do |p|
        next if x26?(p)
        package = {:row => []}
        package[:bloffset] = BL_OFFSET[row_address(p)]
        p.text.each{|x| package[:row] << x}

        (col_start(package[:row])..col_stop(package[:row])).each do |number|
          next unless package[:row][number] > 0x07
          package[:row][number] = iso[package[:row][number] - 32]
        end

        @utf8_packet << package
      end

      process_x26 if x26?(packet[0])
      @utf8_packet
    end

    def process_x26
      x26_row = 0
      x26_col = 0

      packet[0].x26.each do |triplit|
        j = unham_24_18((triplit.data2 << 16) | (triplit.data1 << 8) | triplit.data0)
        data = (j & 0x3f800) >> 11
        mode = (j & 0x7c0) >> 6
        x26_col = j & 0x3f
        row_address_group = (x26_col >= 40) && (x26_col <= 63)

        # ETS 300 706, chapter 12.3.1, table 27: set active position
        if (mode == 0x04) && (row_address_group)
          x26_row = map_row_address_to_array(x26_col)
          next 
        end

        # ETS 300 706, chapter 12.3.1, table 27: character from G2 set
        if (mode == 0x0f) && (!row_address_group)
          if data > 31
            @utf8_packet[x26_row][:row][x26_col] = G2[data - 0x20]
          end
        end

        # // ETS 300 706, chapter 12.3.1, table 27: G0 character with diacritical mark
        if (mode >= 0x11) && (mode <= 0x1f) && (!row_address_group)
          # A - Z
          if (data >= 65) && (data <= 90)
            @utf8_packet[x26_row][:row][x26_col] = G2_ACCENTS[mode - 0x11][data - 65]
          # a - z
          elsif (data >= 97) && (data <= 122)
            @utf8_packet[x26_row][:row][x26_col] = G2_ACCENTS[mode - 0x11][data - 71]
          end
        end
      end
    end

    def row_to_json(row)
      col_start = col_start(row)
      col_stop = col_stop(row)
      text = {}
      content = []

      (0..col_start - 1).each do |n|
        if row[n] <= 0x07
          text[:fgcolor] = row[n]
          text[:bgcolor] = 0
          text[:txt] = ""
        end
      end

      (col_start..col_stop).each do |n|
        if row[n].class == String
          text[:txt] << row[n]
          next
        elsif row[n] <= 0x07
          content << text.clone
          text[:fgcolor] = row[n]
          text[:bgcolor] = 0
          text[:txt] = " " # added space to takenup by the colour
        end
      end
      content << text
    end

    def process_package(language)
      sub_hash = {:timestamp => timestamp}
      case package_type
        when 0x0f # build
          iso = lang_to_iso(language)
          sub_hash[:row] = []
          sub_hash[:code] = "build"
          packet_to_utf8(iso).each do |n|
            row = {
              :bloffset => n[:bloffset],
              :content => row_to_json(n[:row])
              }
            sub_hash[:row] << row
          end
        when 0x16 # reveal
          sub_hash[:code] = "reveal"
        when 0x18 # clear
          sub_hash[:code] = "clear"
        when 0x0E # disconnect
          sub_hash[:code] = "connect_disconnect"
      end
      sub_hash
    end

  end
end