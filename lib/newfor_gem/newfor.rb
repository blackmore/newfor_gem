require 'bindata'
require 'newfor_gem/hamming'
require 'newfor_gem/character_sets'

module NewforGem
	class Newfor < BinData::Record
		# subtitle package structure
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		uint8 :package
		uint8 :subte_info, :onlyif => :build_data
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		def build_data
			package == 0x0f
		end
	end
	
end