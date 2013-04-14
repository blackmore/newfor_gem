require 'newfor_gem/newfor'

module NewforGem

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# 	small bit of code to ensure that all data going through the gem 
	# 	is to non parity encoded
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


  def self.parse(data, *lang)
    lang[0] ||= "EN" # Default to english
    obj = Newfor.read(ensure_odd_parity(data))
    obj.process_package(lang[0])
  end
end
