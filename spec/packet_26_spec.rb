# encoding: UTF-8
require "json"
require 'newfor_gem'
require "newfor_gem/newfor"
require "newfor_gem/package_mappings"

describe NewforGem do
  include PackageMappings
  
  # PACKET_26           = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x22\x6d\xc3\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x73\x39\x20\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20" 
  # BUILD               = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"


  it "should return the number of rows" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.number_of_rows.should == 2
  end

  it "should return true for packet_26" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.is_packet_26?.should == true
  end

  it "should not be packet_26" do
    obj = NewforGem::Newfor.read(BUILD)
    obj.is_packet_26?.should == false
  end

  it "should return a 40 chr string" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.slice_packet_data.length.should equal(36) 
  end

    it "should return a 40 chr string" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.push_to_chr_list.length.should eql(12)
  end

  it "should do something" do
    P26[189].should eql ("\u00D1")
  end

  it "should do something" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.create_packet_26_array.length.should eql (12)
    obj.create_packet_26_array.last.should eql ("Ñ")
  end

  it "should do something" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.should eql (12)
  end



  # it "should return a json string of the build data" do
  #   json_str = NewforGem.to_json(BUILD)
  #   json_str.to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcdefghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]\}/
  # end
  
  # it "should return 'SKIP'" do
  #   json_str = NewforGem.to_json(BROKEN)
  #   json_str.to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"skip\"\}/
  # end  
  
end
