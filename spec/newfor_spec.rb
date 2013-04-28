# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'
require 'turn/autorun'

require 'json'
require 'newfor_gem'
require 'newfor_gem/newfor'
require 'newfor_gem/hamming'

describe NewforGem::Newfor do
	CLEAR        = "\x18"
	BUILD        = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  PX_26        = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x1e\xbd\xd0\x25\x6d\x43\x3e\xd1\x4e\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x53\x31\x34\x20\xa0\x20\xa0\x20\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20" 
  GERMAN_BUILD = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x5d\x5d\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  ES_PKT_S2    = "\x0f\x47\x02\x49\x20\x0d\x07\x0b\x0b\x53\x32\x20\x71\x77\x65\x72\x74\x79\x75\x69\x6f\x70\x61\x73\x64\x66\x67\x68\x6a\x6b\x6c\x7c\x7a\x78\x63\x76\x62\x6e\x6d\x0a\x0a\x20\x20\x20"
  KLIVE        = "\x8f\x02\x02\x38\x0d\x07\x0b\x0b\x61\x6e\x73\xf7\xe5\xf2\x20\xf4\xef\x20\xf4\x68\xe9\x73\xae\x20\xd0\x68\xe9\xec\x8a\x8a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x10"
  TWO_LINE     = "\x0f\x49\x02\x64\x0d\x07\x0b\x0b\x41\x6c\x6c\x20\x77\x6f\x72\x6b\x20\x61\x6e\x64\x20\x6e\x6f\x20\x70\x6c\x61\x79\x20\x6d\x61\x6b\x65\x73\x20\x4a\x61\x63\x6b\x20\x61\x0a\x0a\x20\x02\x38\x0d\x07\x0b\x0b\x64\x75\x6c\x6c\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  LONG         = "\x0f\x47\x02\x38\x0d\x06\x0b\x0b\x61\x73\x6a\x64\x68\x67\x66\x61\x6a\x73\x67\x68\x64\x66\x6a\x61\x68\x73\x67\x64\x66\x6a\x68\x73\x61\x67\x64\x66\x6a\x61\x73\x68\x64\x67\x66\x6a"

  def read_obj(j)
    NewforGem::Newfor.read(j)
  end

  def parse_obj(j)
    NewforGem.parse(j)
  end

	it "must return a Clear package type" do
    read_obj(CLEAR)[:package_type].must_equal 0x18
    obj = parse_obj(CLEAR)
    obj['code'].must_equal "clear"
    obj['rows'].must_be_nil
  end

  it "must return a Build package type with two text lines" do
  	read_obj(BUILD)[:package_info].must_equal 0x0c
    obj = parse_obj(BUILD)
    obj['code'].must_equal "build"
    obj['rows'].must_be_instance_of Array
    obj['rows'].length.must_equal 2
  end

  it "must retrun length of x26 and mst be 13" do
    obj = read_obj(PX_26)
  	obj.packet[0].address1.must_equal 12
  end

  it "must return the chrs for German" do
    obj = NewforGem.parse(GERMAN_BUILD, "DE")
    obj['rows'][0]['text'].must_include "Ü"
  end

  it "wont include Ü but will default to EN »" do
    obj = NewforGem.parse(GERMAN_BUILD)
    obj['rows'][0]['text'].wont_include "Ü"
    obj['rows'][0]['text'].must_include "»"
  end

  it "must parse a long line" do
    obj = read_obj(LONG)
    obj[:package_type].must_equal 0x0f
  end

  it "must parse a long line" do
    obj = NewforGem.parse(LONG)
    obj['rows'][0]['text'].must_include "asjdhgfajsghdfjahsgdfjhsagdfjashdgfj"
  end

  it "must give baseline + 0" do
    obj = NewforGem.parse(LONG)
    obj['rows'][0]['bloffset'].must_equal 0
  end

  it "must give baseline + 1" do
    obj = NewforGem.parse(TWO_LINE)
    obj['rows'][0]['bloffset'].must_equal 1
  end
    BL_OFFSET = [
    0xff, 0xff, 0xff, 0xff, 0x05, 0xff, 0x04, 0xff, 0x03, 0xff, 0x02, 0xff, 0x01, 0xff, 0x00, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
  #   0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
  #   0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x04,
  #   0x00, 0x04, 0x00, 0x02, 0x00, 0x01, 0x00,
  #   0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 
  #   0x04
  ]

  it "must give baseline + 1" do
    BL_OFFSET[60 - 0x30].must_equal 1
    # obj = NewforGem.parse(TWO_LINE)
    # obj['rows'][0]['bloffset'].must_equal 1
  end

end
