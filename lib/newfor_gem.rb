require 'newfor_gem/newfor'

module NewforGem

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# 	small bit of code to ensure that all dat going through the gem 
	# 	is set to non pirity
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  def self.parse(data, *codepage)
    lang = codepage[0] ||= "EN" # Default to english
    obj = Newfor.read(ensure_odd_parity(data))
    obj.clean(lang)
  end
end
