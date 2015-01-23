module StringHelper
  def matches_text(user_string, app_string)
    user_string.downcase.match(app_string.downcase) ? true : false
  end

  def is_yes(user_string)
    return true if (/\A\s*y+\s*\z/.match(user_string.downcase) || /\A\s*yes\s*\z/.match(user_string.downcase))
  end

  def is_no(user_string)
    return true if (/\A\s*n\s*\z/.match(user_string.downcase) || /\A\s*no\s*\z/.match(user_string.downcase))
  end

  def break_on_octothorpes(string)
    string.split("#")
  end

  def break_strings_on_octothorpes(strings)
    strings.map {|s| break_on_octothorpes(s)}.flatten.map {|s| s.strip }
  end

end