module StringHelper
  def matches_text(user_string, app_string)
    user_string.downcase.match(app_string.downcase) ? true : false
  end
end