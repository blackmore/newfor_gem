require 'bindata'
require 'newfor_gem/hamming'
require 'newfor_gem/character_sets'

module NewforGem
	class Newfor < BinData::Record

	# default language = English
	@@lang = EN
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

    def disconnect?
      package_type == 0x0E
    end

    def reveal?
      package_type == 0x16
    end

    def clear?
      package_type == 0x18
    end

		def number_of_rows
			UNHAM_8_4[package_info] & 0x07
		end

		def col_stop(row)
			row.index(0x0a) - 1
		end

		def col_start(row)
			row.rindex(0x0b) + 1
		end

		def x26?(packet)
			packet.address1 == 12
		end

		def language(lang)
			case lang
				when /en/
					EN
				when /it/
					IT
				when /de/
					DE
				else
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

		def packet_to_utf8
			@@final_packet = []

			packet.each do |p|
				row = []
				unless x26?(p)
					p.text.each{|x| row << x}
					(col_start(row)..col_stop(row)).each do |number|
						row[number] = @@lang[row[number] - 32]
					end
					@@final_packet << row
				end
			end

			process_x26 if x26?(packet[0])
			@@final_packet
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
          case x26_col
          	when 58
          	  x26_row = 0
          	when 58
          	  x26_row = 1
          	end
          next 
        end

				# ETS 300 706, chapter 12.3.1, table 27: character from G2 set
				if (mode == 0x0f) && (!row_address_group)
					if data > 31
						@@final_packet[x26_row][x26_col] = G2[data - 0x20]
					end
				end

				# // ETS 300 706, chapter 12.3.1, table 27: G0 character with diacritical mark
				if (mode >= 0x11) && (mode <= 0x1f) && (!row_address_group)
					# A - Z
					if (data >= 65) && (data <= 90)
						@@final_packet[x26_row][x26_col] = G2_ACCENTS[mode - 0x11][data - 65]
					# a - z
					elsif (data >= 97) && (data <= 122)
						@@final_packet[x26_row][x26_col] = G2_ACCENTS[mode - 0x11][data - 71]
					end
				end
			end
		end

		def process_package(lang)
			@@lang = language(lang)
		end

	end
end