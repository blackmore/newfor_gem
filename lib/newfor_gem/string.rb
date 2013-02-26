class String
  def trim_padding
    str = self.gsub!(/^\x20*|\x20$/, '')
    str.remove_start_end_tags
  end

  def remove_start_end_tags
    self.gsub!(/\x0B*/, '')
    self.gsub!(/\x0A*/, '')
    self.remove_color_tags
  end

  def remove_color_tags
    self.gsub!(/\x0D./, '')
    self
  end
end
