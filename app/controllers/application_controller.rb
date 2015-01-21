class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login

  include SessionsHelper

  private
    def require_login
      unless current_user
        redirect_to signin_url
      end
    end
end
