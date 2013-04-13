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



