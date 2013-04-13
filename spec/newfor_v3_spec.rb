# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'

require 'json'
require 'newfor_gem'
require 'newfor_gem/newfor'
require 'newfor_gem/hamming'

describe NewforGem::Newfor do
	CLEAR = "\x18"
	BUILD = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  PX_26 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x1e\xbd\xd0\x25\x6d\x43\x3e\xd1\x4e\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x53\x31\x34\x20\xa0\x20\xa0\x20\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20" 
  GERMAN_BUILD = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x5d\x5d\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  ES_PKT_S2 = "\x0f\x47\x02\x49\x20\x0d\x07\x0b\x0b\x53\x32\x20\x71\x77\x65\x72\x74\x79\x75\x69\x6f\x70\x61\x73\x64\x66\x67\x68\x6a\x6b\x6c\x7c\x7a\x78\x63\x76\x62\x6e\x6d\x0a\x0a\x20\x20\x20"  




	build_obj = NewforGem::Newfor.read(BUILD)
	clear_obj = NewforGem::Newfor.read(CLEAR)
	px_26_obj = NewforGem::Newfor.read(PX_26)
  de_obj = NewforGem::Newfor.read(GERMAN_BUILD)
  es_obj = NewforGem::Newfor.read(ES_PKT_S2)

  nf_obj = NewforGem::Newfor.new

	it "must return first byte in package" do
    clear_obj[:package_type].must_equal 0x18
  end

  it "must retrun subtitle info" do
  	build_obj[:package_info].must_equal 0x0c
  end

  it "must retrun number of rows = 2" do
  	build_obj.number_of_rows.must_equal 2
  end

  it "must retrun length of x26 and mst be 13" do
  	px_26_obj.packet[0].x26.length.must_equal 13
  end

  it "will return an array with standard char in" do
    build_obj.packet_to_utf8.must_equal [[32, 32, 13, 7, 11, 11, "1", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 10, 10, 32, 32, 32, 32, 32], [32, 32, 13, 7, 11, 11, "2", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ".", 10, 10, 32, 32, 32, 32]]
  end

  it "will replace the special chars in the package" do
      skip
        x26_row = 0
        x26_col = 0

        #\x0f\x0c\x02\x0c\x15\x53\x93\x80
        #\x0f\x1b\x02\x0c\x15\x79\x93\x00
        data0 = 0x79
        data1 = 0x93
        data2 = 0x00
        j = nf_obj.unham_24_18((data2 << 16) | (data1 << 8) | data0)
        data = (j & 0x3f800) >> 11
        mode = (j & 0x7c0) >> 6
        address = j & 0x3f
        row_address_group = (address >= 40) && (address <= 63)

        # ETS 300 706, chapter 12.3.1, table 27: set active position
        if (mode == 0x04) && (row_address_group)
          case address
          when 58
            x26_row = 0
          when 58
            x26_row = 1
          end
        end
        mode.must_equal 0x04
        address.must_equal 62
        x26_row.must_equal 0
  end




end
