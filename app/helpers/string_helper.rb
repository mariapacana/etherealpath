module StringHelper
  def matches_text(user_string, app_string)
    user_string.downcase.match(app_string.downcase) ? true : false
  end

  def is_yes(user_string)
    return true if (/\s*y+\s*/.match(user_string.downcase) || /yes/.match(user_string.downcase))
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

  def standardize_location(user_string)
    if is_rooted(user_string)
      "Rooted"
    elsif is_sf(user_string)
      "SF"
    elsif is_east_bay(user_string)
      "East Bay"
    end
  end

  def is_rooted(user_string)
    options = [/rooted/, /1/]
    is_location(user_string, options)
  end

  def is_sf(user_string)
    options = [/sf/, /2/]
    is_location(user_string, options)
  end

  def is_east_bay(user_string)
    options = [/east bay/, /eb/, /ebay/, /east/, /3/]
    is_location(user_string, options)
  end

  def is_location(user_string, options)
    options.each do |option|
      return true if option.match(user_string.downcase)
    end
    return false
  end
end