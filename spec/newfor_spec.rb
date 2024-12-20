# -*- encoding: utf-8 -*-
require 'spec_helper'

describe NewforGem::Newfor do
	CLEAR        = "\x18"
  DISCONECT    = "\x0E"
  REVEAL       = "\x16\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
	BUILD        = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  PX_26        = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x1e\xbd\xd0\x25\x6d\x43\x3e\xd1\x4e\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x53\x31\x34\x20\xa0\x20\xa0\x20\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20" 
  GERMAN_BUILD = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x5d\x5d\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  ES_PKT_S2    = "\x0f\x47\x02\x49\x20\x0d\x07\x0b\x0b\x53\x32\x20\x71\x77\x65\x72\x74\x79\x75\x69\x6f\x70\x61\x73\x64\x66\x67\x68\x6a\x6b\x6c\x7c\x7a\x78\x63\x76\x62\x6e\x6d\x0a\x0a\x20\x20\x20"
  KLIVE        = "\x8f\x02\x02\x38\x0d\x07\x0b\x0b\x61\x6e\x73\xf7\xe5\xf2\x20\xf4\xef\x20\xf4\x68\xe9\x73\xae\x20\xd0\x68\xe9\xec\x8a\x8a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x10"
  TWO_LINE     = "\x0f\x49\x02\x64\x0d\x07\x0b\x0b\x41\x6c\x6c\x20\x77\x6f\x72\x6b\x20\x61\x6e\x64\x20\x6e\x6f\x20\x70\x6c\x61\x79\x20\x6d\x61\x6b\x65\x73\x20\x4a\x61\x63\x6b\x20\x61\x0a\x0a\x20\x02\x38\x0d\x07\x0b\x0b\x64\x75\x6c\x6c\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  LONG         = "\x0f\x47\x02\x38\x0d\x06\x0b\x0b\x61\x73\x6a\x64\x68\x67\x66\x61\x6a\x73\x67\x68\x64\x66\x6a\x61\x68\x73\x67\x64\x66\x6a\x68\x73\x61\x67\x64\x66\x6a\x61\x73\x68\x64\x67\x66\x6a"
  IN_COLOUR    = "\x0f\x49\x02\x64\x0d\x07\x0b\x0b\x41\x6c\x6c\x65\x6e\x20\x6e\x6f\x77\x20\x72\x65\x70\x6f\x72\x74\x73\x2e\x03\x53\x70\x65\x63\x74\x61\x63\x75\x6c\x61\x72\x2c\x0a\x0a\x20\x20\x20\x02\x38\x0d\x03\x0b\x0b\x69\x73\x6e\x27\x74\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"

  def read_obj(j)
    NewforGem::Newfor.read(j)
  end

  def parse_obj(j)
    NewforGem.parse(j)
  end

  it "must return package type 0x18" do
    read_obj(CLEAR)[:package_type].must_equal 0x18
  end

	it "must return a clear" do
    parse_obj(CLEAR)[:code].must_equal "clear"
  end

  it "must return a zero array for clear package type" do
    parse_obj(CLEAR)[:row].must_be_nil
  end

  it "must return package type 0x16" do
    read_obj(REVEAL)[:package_type].must_equal 0x16
  end

  it "must return a reveal" do
    parse_obj(REVEAL)[:code].must_equal "reveal"
  end

  it "must return a zero array for clear package type" do
    parse_obj(CLEAR)[:row].must_be_nil
  end

  it "must return a disconnect" do
    parse_obj(DISCONECT)[:code].must_equal "connect_disconnect"
  end

  it "must return package type 0x0F" do
    read_obj(BUILD)[:package_type].must_equal 0x0F
  end

  it "must return a Build package type with two text lines" do
    parse_obj(BUILD)[:code].must_equal "build"
  end

  it "must return an instance of an array" do
    parse_obj(BUILD)[:row].must_be_instance_of Array
  end

  it "must return an array length of 2" do
    parse_obj(BUILD)[:row].length.must_equal 2
  end

  it "must retrun length of x26 and mst be 13" do
    read_obj(PX_26).packet[0].address1.must_equal 12
  end

  it "must return the chrs for German" do
    obj = NewforGem.parse(GERMAN_BUILD, "DE")
    obj[:row][0][:content][0][:txt].must_include "Ü"
  end

  it "must default to EN with no lang code" do
    obj = NewforGem.parse(KLIVE)
    obj[:row][0][:content][0][:txt].must_include "P"
  end

  it "must default to EN with unsupported lang code" do
    obj = NewforGem.parse(KLIVE, "ZH")
    obj[:row][0][:content][0][:txt].must_include "P"
  end

  it "must default to ES" do
    obj = NewforGem.parse(ES_PKT_S2, "ES")
    obj[:row][0][:content][0][:txt].must_include "ñ"
  end

  it "must default to PT" do
    obj = NewforGem.parse(ES_PKT_S2, "PT")
    obj[:row][0][:content][0][:txt].must_include "ñ"
  end

  it "German first line wont include Ü as it will default to english" do
    obj = NewforGem.parse(GERMAN_BUILD)
    obj[:row][0][:content][0][:txt].wont_include "Ü"
  end

  it "German first line will include » as it will default to english" do
    obj = NewforGem.parse(GERMAN_BUILD)
    obj[:row][0][:content][0][:txt].must_include "»"
  end

  it "must parse a long line" do
    obj = read_obj(LONG)
    obj[:package_type].must_equal 0x0f
  end

  it "must parse a long line" do
    obj = NewforGem.parse(LONG)
    obj[:row][0][:content][0][:txt].must_include "asjdhgfajsghdfjahsgdfjhsagdfjashdgfj"
  end

  it "must split the rows into content arrays" do
    obj = NewforGem.parse(IN_COLOUR)
    obj[:row][0][:content][1][:txt].must_equal " Spectacular,"
    obj[:row][0][:content][0][:txt].must_equal "Allen now reports."
  end

  it "must first line colour is 7" do
    obj = NewforGem.parse(IN_COLOUR)
    obj[:row][0][:content][0][:fgcolor].must_equal 7
  end

  it "fgcolor must be a Fixnum" do
    obj = NewforGem.parse(TWO_LINE)
    obj[:row][0][:content][0][:fgcolor].must_be_instance_of BinData::Uint8
  end

  it "must give baseline + 0" do
    obj = NewforGem.parse(LONG)
    obj[:row][0][:bloffset].must_equal 0
  end

  it "must give baseline + 1" do
    obj = NewforGem.parse(TWO_LINE)
    obj[:row][0][:bloffset].must_equal 1
  end
  
  BL_OFFSET = [
    0xff, 0xff, 0xff, 0xff, 0x05, 0xff, 0x04, 0xff, 0x03, 0xff, 0x02, 0xff, 0x01, 0xff, 0x00, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
  ]

  it "must give baseline + 1" do
    BL_OFFSET[60 - 0x30].must_equal 1
  end



end
