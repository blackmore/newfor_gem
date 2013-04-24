require 'bindata'
require 'newfor_gem/hamming'
require 'newfor_gem/character_sets'

module NewforGem
# \x1e\xbd\xd0
    def self.unham_24_18(a)
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
# 0/5 => 2b 93 80 x26_col: 52
# 1/5 => 32 93 00 x26_col: 54
# 2/5 => 4a 93 00 x26_col: 56
# 3/5 => 60 93 80 x26_col: 60
# 4/5 => 79 93 00 
        j = unham_24_18(( 0x00<< 16) | (0x93 << 8) | 0x79)
        puts "data: #{(j & 0x3f800) >> 11}"
        puts "mode: #{(j & 0x7c0) >> 6}"
        puts "x26_col: #{x26_col = j & 0x3f}"
        puts "row_address_group: #{(x26_col >= 40) && (x26_col <= 63)}"
end