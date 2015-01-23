module StringHelper
  def matches_text(user_string, app_string)
    user_string.downcase.match(app_string.downcase) ? true : false
  end
  def is_yes(user_string)
    /\A\s*y+\s*\z/.match(user_string.downcase) || /\A\s*yes\s*\z/.match(user_string.downcase)
  end
  def is_no(user_string)
    /\A\s*n\s*\z/.match(user_string.downcase) || /\A\s*no\s*\z/.match(user_string.downcase)
  end
end