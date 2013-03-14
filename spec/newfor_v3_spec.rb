# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'

require 'json'
require 'newfor_gem'
# require 'newfor_gem/newfor'

describe NewforGem do
	CLEAR = "\x18"
	BUILD = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"

	it "must return first byte in package" do
    obj = NewforGem::Newfor.read(CLEAR)
    obj.must_equal 0x18
  end

 #  it "must retrun subtitle info" do
 #  	NewforGem::Newfor.read(BUILD)['subte_info'].must_equal 0x0c
 #  end

 #  it "must retrun subtitle info" do
 #  	obj = NewforGem::Newfor.read(BUILD)
 #  	obj.subte_info.must_equal 6
 #  end
end