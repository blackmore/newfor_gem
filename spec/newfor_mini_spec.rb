# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'

require "json"
require "newfor_gem"

describe NewforGem do

	it "will return true on clear data" do
    obj = NewforGem::Newfor.read(CLEAR)
    obj.is_clear_data?.must_equal true
  end

  it "will return true on build data" do
    obj = NewforGem::Newfor.read(CLEAR)
    obj.is_build_data?.wont_equal true
  end

  it "will return true on build data" do
    obj = NewforGem::Newfor.read(BUILD)
    obj.is_build_data?.must_equal true
  end

  it "will return true on build data" do
    obj = NewforGem::Newfor.read(BUILD)
    obj.is_clear_data?.wont_equal true
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

describe Packet26 do
    
  it "should return the number of rows" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.number_of_rows.must_equal 2
  end

  it "row infor must include 0c to indicate its a package26 row" do
    obj = NewforGem::Newfor.read(PACKET_26)
    obj.rows[0].row_info.must_include "\x0c"
  end
end



