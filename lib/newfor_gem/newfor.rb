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
      t = Time.now
      t.strftime("%H:%M:%S:%3N")
    end

    def language(lang)
      case lang
        when /EN/
          EN
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
      @final_packet.each_index do |i|
        return i if @final_packet[i]['row_address'] == ROW_MAP[r]
      end
      nil
    end

    def packet_to_utf8
      @final_packet = []
      @lang ||= EN

      packet.each do |p|
        package = {}
        row = []
        #packet_hash {}
        # y = row_address(p)
        unless x26?(p)
          p.text.each{|x| row << x}
          (col_start(row)..col_stop(row)).each do |number|
            row[number] = @lang[row[number] - 32]
          end
          package['row_address'] = row_address(p)
          package['row'] = row
          @final_packet << package
        end
      end

      process_x26 if x26?(packet[0])
      @final_packet
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
            @final_packet[x26_row]['row'][x26_col] = G2[data - 0x20]
          end
        end

        # // ETS 300 706, chapter 12.3.1, table 27: G0 character with diacritical mark
        if (mode >= 0x11) && (mode <= 0x1f) && (!row_address_group)
          # A - Z
          if (data >= 65) && (data <= 90)
            @final_packet[x26_row]['row'][x26_col] = G2_ACCENTS[mode - 0x11][data - 65]
          # a - z
          elsif (data >= 97) && (data <= 122)
            @final_packet[x26_row]['row'][x26_col] = G2_ACCENTS[mode - 0x11][data - 71]
          end
        end
      end
    end

    def colour_and_stuff
      html_text = []
      @final_packet.each do |p|
        row_hash = {}
        col_start = col_start(p['row'])
        col_stop = col_stop(p['row'])
        (0..col_start(p['row']) - 1).each do |number|
          if p['row'][number] <= 0x07
            row_hash['bgcolor'] = nil # to add at a later date
            row_hash['fgcolor'] = p['row'][number]
            row_hash['text'] = p['row'][col_start..col_stop].join
            html_text << row_hash
          end
        end
      end
      html_text
    end

    def process_package(lang)
      sub_hash = {}
      sub_hash['timestamp'] = timestamp
      case package_type
        when 0x0f # build
          @lang = language(lang)
          packet_to_utf8
          sub_hash['code'] = "build"
          sub_hash['rows'] = colour_and_stuff # have to rename this method
        when 0x16 # reveal
          sub_hash['code'] = "reveal"
        when 0x18 # clear
          sub_hash['code'] = "clear"
        when 0x0E # disconnect
          sub_hash['code'] = "connect_disconnect"
      end
      sub_hash
    end

  end
end