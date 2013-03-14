require 'bindata'
require 'newfor_gem/hamming'
require 'newfor_gem/character_sets'

module NewforGem
	class Newfor < BinData::Record
		# subtitle package structure
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		uint8 :package
		uint8 :subte_info, :onlyif => :build_data

		# array :rows, :initial_length => :number_of_rows, :onlyif => :build_data? do
  #     string :row_info, :read_length => 2
  #     string :text, :read_length => 40
  #   end
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		def build_data
			package == 0x0f
		end

		def number_of_rows
			UNHAM_8_4[subte_info] & 0x07
		end
	end
	
end