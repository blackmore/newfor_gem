require "newfor_gem/package26_mappings"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# if packet26 rows[0].text ? split into chunks of three bytes. Each 
# chuck contains a modifier and character. Use the package26_mappings 
# matrix with the modifier and character as the indexes.
# 
# |    8   |  |  4 |  | |    7   |
# |Skip****|**|mod*|**|*|char****|
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

class Packet26 < BinData::Record
  include Packet26Mappings
	uint8  :framing
	string :magazine, :read_length => 2
	uint8  :designation

	array :char_array, :initial_length => 12 do
  	skip 	:length => 1
  	bit2  :unused1
  	bit4  :modifier
    resume_byte_alignment
  	bit1  :unused2
  	bit7  :character
  end

  def special_chars
    array = []
    char_array.each do |chr|
      break if chr[:character] == 0
      array << P26[chr[:modifier]][chr[:character]]
    end
    array.reverse
  end
end