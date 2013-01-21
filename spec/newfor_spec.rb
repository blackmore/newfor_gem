# -*- encoding: utf-8 -*-
require "json"
require "newfor_gem"
require "newfor_gem/newfor"
require "newfor_gem/package_mappings"

describe NewforGem do
  CLEAR               = "\x18"
  BUILD               = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  GERMAN_BUILD        = "\x0F\x0C\x02\x64\x20\x20\x0D\x07\x0B\x0B\x31\x61\x62\x63\x64\x5d\x5d\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x0A\x0A\x20\x20\x20\x20\x20\x02\x38\x20\x20\x0D\x07\x0B\x0B\x32\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x2E\x0A\x0A\x20\x20\x20\x20"
  PACKET_26           = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x1e\xbd\xd0\x25\x6d\x43\x3e\xd1\x4e\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x53\x31\x34\x20\xa0\x20\xa0\x20\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20" 
  KLIVE               = "\x8f\x02\x02\x38\x0d\x07\x0b\x0b\x61\x6e\x73\xf7\xe5\xf2\x20\xf4\xef\x20\xf4\x68\xe9\x73\xae\x20\xd0\x68\xe9\xec\x8a\x8a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x10"
  TWO_LINE            = "\x0f\x49\x02\x64\x0d\x07\x0b\x0b\x41\x6c\x6c\x20\x77\x6f\x72\x6b\x20\x61\x6e\x64\x20\x6e\x6f\x20\x70\x6c\x61\x79\x20\x6d\x61\x6b\x65\x73\x20\x4a\x61\x63\x6b\x20\x61\x0a\x0a\x20\x02\x38\x0d\x07\x0b\x0b\x64\x75\x6c\x6c\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
#                                                        \x1E\xBD\xD0   %  m   C   >  \xD1 N   t  \xFF\x80t\xFF\x80t\xFF\x80t\xFF\x80t\xFF\x80t\xFF\x80t\xFF\x80t\xFF\x80t\x7F\xFF

  
  it "should return true on clear data" do
    obj = NewforGem::Newfor.read(CLEAR)
    obj.is_clear_data?.should == true
    obj.is_build_data?.should == false
    obj.is_reveal_data?.should == false
  end
  
  it "should return true to a build data type" do
    obj = NewforGem::Newfor.read(BUILD)
    obj.is_build_data?.should == true
    obj.is_clear_data?.should == false  
  end
  
  it "should return a bindata" do
    obj = NewforGem::Newfor.read(BUILD)
    obj.rows[1].text.should == "  \r\a\v\v2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\n\n    "
  end

  
  it "should return a clear hash" do
    obj = NewforGem::Newfor.read(CLEAR)
    obj.clean(nil).to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"clear\"\}/
  end
  
  it "should not parse str as German" do
    op = NewforGem.parse(BUILD)
    op['code'].should_not == "clear"
  end
  
  it "should not parse str as German" do
    op = NewforGem.parse(CLEAR)
    op['code'].should == "clear"
  end
  
  it "should not parse str as German" do
    op = NewforGem.parse(CLEAR, "DE")
    op['code'].should == "clear"
  end
  
  it "should not parse str as German" do
    op = NewforGem.parse(BUILD, "DE")
    op['code'].should == "build"
  end

  it "should build string" do
    op = NewforGem.parse(KLIVE)
    op['code'].should == "build"
  end

  
  it "should return a build json string" do
    obj = NewforGem::Newfor.read(BUILD)
    obj.clean(nil).to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcdefghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/
  end

  it "Should return two lines" do
    obj = NewforGem::Newfor.read(TWO_LINE)
    obj.clean(nil).to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"All work and no play makes Jack a\",\"dull\"\]}/
  end

    it "should return a build json string" do
    obj = NewforGem.ensure_odd_parity(KLIVE)
    ob = NewforGem::Newfor.read(obj)
    ob.clean(nil).to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"answer to this. Phil\"\]}/
    # ob.clean(nil).to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcdefghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/
  end
  
  it "should return a correct german string" do
    obj = NewforGem::Newfor.read(GERMAN_BUILD)
    obj.clean("DE").to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcdÜÜghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/ 
  end
  
  it "should return a correct English string" do
    obj = NewforGem::Newfor.read(GERMAN_BUILD)
    obj.clean("EN").to_json.should =~ /\{\"timestamp\":\"\d\d:\d\d:\d\d:\d\d\d\",\"code\":\"build\",\"rows\":\[\"1abcd\]\]ghijklmnopqrstuvwxyz\",\"2ABCDEFGHIJKLMNOPQRSTUVWXYZ.\"\]}/
  end
  
  it "should parse str as German" do
    op = NewforGem.parse(GERMAN_BUILD, "DE")
    op['rows'][0].should == "1abcdÜÜghijklmnopqrstuvwxyz"
  end

    it "should parse str as German" do
    op = NewforGem.parse(KLIVE)
    op['rows'][0].should == "answer to this. Phil"
  end
  
  it "should not parse str as German" do
    op = NewforGem.parse(GERMAN_BUILD)
    op['rows'][0].should_not == "1abcdÜÜghijklmnopqrstuvwxyz"
  end
  
end