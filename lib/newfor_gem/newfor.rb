require 'bindata'
require 'newfor_gem/hamming'
require 'newfor_gem/character_sets'

module NewforGem
	class Newfor < BinData::Record
		X26 = "\x02\x0c"
		# subtitle package structure
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		uint8 :package_type
		uint8 :package_info, :onlyif => :build?

	  	array :row, :initial_length => :number_of_rows, :onlyif => :build? do
      		string :subt_info, :read_length => 2
      		uint8 :not_used, :onlyif => lambda { subt_info == X26 }
       		array :x26, :initial_length => 13, :onlyif => lambda { subt_info == X26 } do
        		uint8 :address
        		uint8 :mode
        		uint8 :data
        end
      	string :text, :read_length => 40, :onlyif => lambda { subt_info != X26 }
    end
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		def build?
			package_type == 0x0f
		end

		def number_of_rows
			UNHAM_8_4[package_info] & 0x07
		end

		def unham_24_18(a)
			b0 = a & 0xff
			b1 = (a >> 8) & 0xff
			b2 = (a >> 16) & 0xff
		
			d1_d4 = UNHAM_24_18_D1_D4[b0 >> 2]
			d5_d11 = b1 & 0x7f
			b12_d18 = b2 & 0x7f
		
			d = d1_d4 | (d5_d11 << 4) | (b12_d18 << 11)
			abcdef = UNHAM_24_18_PAR[0][b0] ^ UNHAM_24_18_PAR[1][b1] ^ UNHAM_24_18_PAR[2][b2]
			d ^ UNHAM_24_18_ERR[abcdef]
		end

		# def map_chars
		# 	# A - Z
		# 	if ((data >= 65) && (data <= 90)) page_buffer.text[x26_row][x26_col] = G2_ACCENTS[mode - 0x11][data - 65];
		# 		// a - z
		# 		else if ((data >= 97) && (data <= 122)) page_buffer.text[x26_row][x26_col] = G2_ACCENTS[mode - 0x11][data - 71];
		# 		// other
		# 		else page_buffer.text[x26_row][x26_col] = telx_to_ucs2(data);
		# end

		def decode_triplits
			triplits = []
			row[0].x26.each do |triplit|
				j = unham_24_18((triplit.data << 16) | (triplit.mode << 8) | triplit.address)
				data = (j & 0x3f800) >> 11
				mode = (j & 0x7c0) >> 6
				address = j & 0x3f
				row_address_group = (address >= 40) && (address <= 63)
				
				if row_address_group
					triplits << [row_address_group, address]
					#puts [row_address_group, address, mode, data]
				else
					triplits << [row_address_group, address, (mode - 0x11), (data - 65)]
				end
				# if row_address_group
				# 	triplits << [row_address_group, "row"]
				# else
				# 	# triplits << [row_address_group, address, G2_ACCENTS[mode - 0x11][data]]
				# end
			end
			triplits
		end

	end
	
end