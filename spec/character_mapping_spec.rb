# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'
require 'turn/autorun'
 Turn.config.format = :cool

require 'json'
require 'newfor_gem'
require 'newfor_gem/newfor'
require 'newfor_gem/hamming'

describe "character mapping" do
  # Chr_1 = À
  Chr_1 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x43\xc5\x41\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x31\x41\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_3 = Â
  Chr_3 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\xcb\xcd\xc1\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x33\x41\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_5 = Æ
  Chr_5 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x49\x3d\x61\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x35\x41\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_6 = æ
  Chr_6 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x40\xbd\x71\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x36\x61\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_7 = Ç
  Chr_7 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x43\x6d\x43\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x37\x43\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_9 = É
  Chr_9 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x4b\x49\xc5\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x39\x45\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_11 = È
  Chr_11 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x40\x45\x45\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x31\x31\x45\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_13 = Î
  Chr_13 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\xc3\x4d\x49\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x31\x33\x49\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_15 = Ï
  Chr_15 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x42\x61\xc9\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x31\x35\x49\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_17 = Ô
  Chr_17 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\xc2\x4d\xcf\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x31\x37\x4f\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_19 = Œ
  Chr_19 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x42\xbd\xea\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x31\x39\x4f\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_20 = œ
  Chr_20 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x4b\x3d\xfa\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x32\x30\x6f\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_21 = Ù
  Chr_21 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x49\xc5\x55\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x32\x31\x55\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_23 = Û
  Chr_23 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\xc1\xcd\xd5\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x32\x33\x55\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  # Chr_25 = Ü
  Chr_25 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x40\xe1\x55\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x32\x35\x55\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  M_CHR1 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x18\xbd\xd6\x1f\xbd\x56\x2b\xbd\xd6\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x45\x45\x45\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  M_CHR2 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x12\xbd\xf1\x15\xbd\x71\x21\xbd\xf1\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x61\x61\x61\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  M_CHR3 = "\x0f\x0c\x02\x0c\x15\x53\x93\x80\x5f\xd1\xce\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x49\x20\x0d\x07\x0b\x0b\x53\x33\x20\x51\x57\x45\x52\x54\x59\x55\x49\x4f\x50\x41\x53\x44\x46\x47\x48\x4a\x4b\x4c\xa0\x5a\x58\x43\x56\x42\x4e\x4d\x0a\x0a\x20\x20\x20"  
  M_CHR4 = "\x0f\x1b\x02\x0c\x15\x79\x93\x00\x77\x6d\xc3\x09\xd2\xce\x05\xbe\xd6\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x64\x0d\x07\x0b\x0b\x4b\x6a\x68\x61\x64\x66\x67\x6a\x6b\x6c\x68\x61\x64\x6b\x6c\x66\x67\x20\x6b\x61\x6a\x64\x66\x67\x6b\x6a\x61\x68\x64\x0a\x0a\x20\x20\x20\x20\x20\x02\x38\x0d\x07\x0b\x0b\x66\x67\x6b\x6c\x68\x61\x20\x64\x66\x6b\x6c\x67\x6a\x68\x61\x6b\x64\x6c\x6a\x66\x20\x67\x6b\x6a\x61\x64\x66\xa0\xa0\xa0\x2e\x0a\x0a\x20\x20\x20"
  TEST_1 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x4d\xbd\xd6\x59\xbd\xf1\x5c\x61\xc9\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x61\x20\x74\x65\x73\x74\x20\x45\x61\x49\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  TEST_2 = "\x0f\x0c\x02\x0c\x15\x79\x93\x00\x4d\xbd\xd6\x59\xbd\xf1\x5c\x61\xc9\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x61\x20\x74\x65\x73\x74\x20\xa0\xa0\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  TEST_a = "\x3c\x07\x54\x2c\xc1\x1e\xb8\xac\x6f\x20\x8f\x0b\x08\x00\x45\x00\x00\x7e\xed\xf6\x40\x00\x80\x06\xf5\x12\x0a\x01\x01\xa7\x0a\x01\x01\xc8\x07\x78\x07\xd5\x5c\x28\x3c\xad\x02\xd0\x5c\xa6\x50\x18\xff\xff\x17\xe1\x00\x00\x0f\x0c\x02\x0c\x15\x79\x93\x00\x4d\xbd\xd6\x59\xbd\xf1\x5c\x61\xc9\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x61\x20\x74\x65\x73\x74\x20\x45\x61\x49\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20"
  TEST_b = "\x3c\x07\x54\x2c\xc1\x1e\xb8\xac\x6f\x20\x8f\x0b\x08\x00\x45\x00\x00\x7e\xed\xc4\x40\x00\x80\x06\xf5\x44\x0a\x01\x01\xa7\x0a\x01\x01\xc8\x07\x77\x07\xd5\xa6\x4f\x4f\x6d\x6d\x5d\xc7\x52\x50\x18\xff\xff\x17\xe1\x00\x00\x0f\x0c\x02\x0c\x15\x79\x93\x00\x4d\xbd\xd6\x59\xbd\xf1\x5c\x61\xc9\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\xff\x80\x74\x7f\xff\x02\x38\x20\x20\x20\x20\x20\x20\x0d\x07\x0b\x0b\x74\x68\x69\x73\x20\x69\x73\x20\x61\x20\x74\x65\x73\x74\x20\xa0\xa0\xa0\x2e\x0a\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Use below to find the modifier and character number of a new
#   special character.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  def obj(j)
    NewforGem::Newfor.read(j)
  end

  it "must retrun Chr_1 = À at position 24" do
    obj(Chr_1).packet_to_utf8[0][:row][24].must_equal "À"
  end

  it "must retrun Chr_3 = Â at position 24" do
    obj(Chr_3).packet_to_utf8[0][:row][24].must_equal "Â"
  end

  it "must retrun Chr_5 = Æ at position 24" do
    obj(Chr_5).packet_to_utf8[0][:row][24].must_equal "Æ"
  end

  it "must retrun Chr_6 = æ at position 24" do
    obj(Chr_6).packet_to_utf8[0][:row][24].must_equal "æ"
  end

  it "must retrun Chr_7 = Ç at position 24" do
    obj(Chr_7).packet_to_utf8[0][:row][24].must_equal "Ç"
  end

  it "must retrun Chr_9 = É at position 24" do
    obj(Chr_9).packet_to_utf8[0][:row][24].must_equal "É"
  end

  it "must retrun Chr_11 = È at position 24" do
    obj(Chr_11).packet_to_utf8[0][:row][24].must_equal "È"
  end

  it "must retrun Chr_13 = Î at position 24" do
    obj(Chr_13).packet_to_utf8[0][:row][24].must_equal "Î"
  end

  it "must retrun Chr_15 = Ï at position 24" do
    obj(Chr_15).packet_to_utf8[0][:row][24].must_equal "Ï"
  end

  it "must retrun Chr_17 = Ô at position 24" do
    obj(Chr_17).packet_to_utf8[0][:row][24].must_equal "Ô"
  end

  it "must retrun Chr_19 = Œ at position 24" do
    obj(Chr_19).packet_to_utf8[0][:row][24].must_equal "Œ"
  end

  it "must retrun Chr_20 = œ at position 24" do
    obj(Chr_20).packet_to_utf8[0][:row][24].must_equal "œ"
  end

  it "must retrun Chr_21 = Ù at position 24" do
    obj(Chr_21).packet_to_utf8[0][:row][24].must_equal "Ù"
  end

  it "must retrun Chr_23 = Û at position 24" do
    obj(Chr_23).packet_to_utf8[0][:row][24].must_equal "Û"
  end

  it "must retrun Chr_25 = Ü at position 24" do
    obj(Chr_25).packet_to_utf8[0][:row][24].must_equal "Ü"
  end

  it "must retrun Euro at position 24" do
    #skip
    obj(M_CHR1).packet_to_utf8[0][:row][18..20].must_equal ["€", "€", "€"]
  end

  it "must retrun French chrs at position 24" do
    #skip
    obj(M_CHR2).packet_to_utf8[0][:row][18..20].must_equal ["æ", "æ", "æ"]
  end

  it "must retrun mixed chrs at position 24" do
    #skip
    obj(M_CHR4).packet_to_utf8[1][:row][31..33].must_equal ["Ç", "Ñ", "€"]
    #obj(M_CHR4).packet_to_utf8.must_equal ["Ç", "Ñ", "€"]
  end

end