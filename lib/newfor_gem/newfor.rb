# -*- encoding: utf-8 -*-
require "bindata"
require "newfor_gem/string"
require "newfor_gem/mappings"
require "newfor_gem/package_mappings"

module NewforGem

  def self.ensure_odd_parity(data)
    none_parity = ""
    binary_array = data.unpack('B*')[0].scan(/.{8}/)
    # odd parity check
    binary_array.each do |byte|
      if byte.sum.odd?
        # correct first byte error checking
        corrected_byte = byte.sub(/^./, "0")
        none_parity << [corrected_byte].pack('B*')
      else
        none_parity << [byte].pack('B*')
      end
    end
    none_parity
  end 

  class Newfor < BinData::Record
    include Mappings
    include PackageMappings
    
    uint8 :code
    uint8 :subtitle_info, :onlyif => :is_build_data?

    array :rows, :initial_length => :number_of_rows, :onlyif => :is_build_data? do
      string :row_info, :read_length => 2
      string :text, :read_length => 40
    end

    def number_of_rows
      case subtitle_info.value
        when 12 then 2
        when 71 then 1
        when 27 then 3
        when 73 then 2
        else 1
      end
    end

    def is_connect_disconnect_data?
      code == 14
    end

    def is_build_data?
      code == 15
    end

    def is_reveal_data?
      code == 16
    end

    def is_clear_data?
      code == 24
    end

    def is_packet_26?
      rows[0].row_info.include? "\x0c"
    end

    def slice_packet_data
      rows[0].text.slice(4, 36)
    end

    def character_list
      chr_array = []
      slice_packet_data.each_byte do |c|
        chr_array << c
      end
      chr_array.each_slice(3).to_a
    end

    def create_packet26_array
      @packet26_array = []
      character_list.reverse.each do |p26_block|
        num = p26_block[1]
        if P26[num]
          @packet26_array << P26[num]
        else
          @packet26_array << ""
        end
      end
      @rows = rows.drop(1)
    end
    
    def clean(codepage)
      sub_hash = {}
      @rows = rows
      t = Time.now
      sub_hash['timestamp'] = t.strftime("%H:%M:%S:%3N")

      case code.value
        when 24
          sub_hash['code'] = "clear"
        when 15        
          create_packet26_array if is_packet_26?
          sub_hash['code'] = "build"
          sub_hash['rows'] = process_row_data(@rows, codepage)
        when 16
          sub_hash['code'] = "reveal"
        when 14
          sub_hash['code'] = "connect_disconnect"
        else
          sub_hash['code'] = "skip"
      end
      sub_hash
    end

    def process_row_data(lines, codepage)
      arr = Array.new
      lines.each do |line|
        str = line.text.trim_padding
        case codepage
          when "DE"
            arr << mapping(str, GERMAN)
          when "ES"
            arr << mapping(str, SPANISH)
          else
            arr << str
        end
      end
      arr
    end

    def mapping(str, language)
      string = ""
      str.each_byte do |c|
        if c == 160
          string << @packet26_array.pop if ! @packet26_array.empty?
          next
        elsif ! language[c].empty?
          string << language[c]
          next
        else
          string << c
        end
      end
      string
    end
    
  end
end