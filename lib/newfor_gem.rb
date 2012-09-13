require "newfor_gem/newfor"

module NewforGem
  def self.parse(data, *codepage)
    lang = codepage[0] ||= "EN" # Default to english
    obj = Newfor.read(data)
    obj.clean(lang)
  end
end
