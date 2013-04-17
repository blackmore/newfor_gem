# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'

require "json"
require "newfor_gem"

describe NewforGem do
  CLEAR               = "\x18"
  BUILD               = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  GERMAN_BUILD        = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x5d\x5d\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  PACKET_26           = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x1e\xbd\xd0\x25\x6d\x43\x3e\xd1\x4e\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x53\x31\x34\x20\xa0\x20\xa0\x20\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20" 

  it "should return true on clear data" do
    obj = NewforGem.parse(CLEAR)
    obj['code'].must_equal "clear"
  end
  
  # it "should return true to a build data type" do
  #   obj = NewforGem::Newfor.read(BUILD)
  #   obj.is_build_data?.must_equal true
  #   obj.is_clear_data?.must_equal false  
  # end
  
  # it "should return a bindata" do
  #   obj = NewforGem::Newfor.read(BUILD)
  #   obj.rows[1].text.must_equal "  \r\a\v\v2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\n\n    "
  # end
  
  # it "should return a clear hash" do
  #   obj = NewforGem::Newfor.read(CLEAR)
  #   obj.clean(nil).to_json.must_match(/\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"clear\"\}/)
  # end
  
  # it "should not parse str as German" do
  #   op = NewforGem.parse(BUILD)
  #   op['code'].wont_equal "clear"
  # end
  
  # it "should not parse str as German" do
  #   op = NewforGem.parse(CLEAR)
  #   op['code'].must_equal "clear"
  # end
  
  # it "should not parse str as German" do
  #   op = NewforGem.parse(CLEAR, "DE")
  #   op['code'].must_equal "clear"
  # end
  
  # it "should not parse str as German" do
  #   op = NewforGem.parse(BUILD, "DE")
  #   op['code'].must_equal "build"
  # end

  # it "should build string" do
  #   op = NewforGem.parse(KLIVE)
  #   op['code'].must_equal "build"
  # end

  # it "should return a build json string" do
  #   obj = NewforGem::Newfor.read(BUILD)
  #   obj.clean(nil).to_json.must_match(/\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcdefghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/)
  # end

  # it "Should return two lines" do
  #   obj = NewforGem::Newfor.read(TWO_LINE)
  #   obj.clean(nil).to_json.must_match(/\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"All work and no play makes Jack a\",\"dull\"\]}/)
  # end

  # it "should return a build json string" do
  #   obj = NewforGem.ensure_odd_parity(KLIVE)
  #   ob = NewforGem::Newfor.read(obj)
  #   ob.clean(nil).to_json.must_match(/\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"answer to this. Phil\"\]}/)
  # end
  
  # it "should return a correct german string" do
  #   obj = NewforGem::Newfor.read(GERMAN_BUILD)
  #   obj.clean("DE").to_json.must_match(/\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcdÜÜghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/ )
  # end
  
  # it "should return a correct English string" do
  #   obj = NewforGem::Newfor.read(GERMAN_BUILD)
  #   obj.clean("EN").to_json.must_match(/\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcd\]\]ghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/)
  # end
  
  # it "should parse str as German" do
  #   op = NewforGem.parse(GERMAN_BUILD, "DE")
  #   op['rows'][0].must_equal "1abcdÜÜghijklmnopqrstuvwxyz"
  # end

  # it "should parse str as German" do
  #   op = NewforGem.parse(KLIVE)
  #   op['rows'][0].must_equal "answer to this. Phil"
  # end
  
  # it "should not parse str as German" do
  #   op = NewforGem.parse(GERMAN_BUILD)
  #   op['rows'][0].wont_equal "1abcdÜÜghijklmnopqrstuvwxyz"
  # end
end