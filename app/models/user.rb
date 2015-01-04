class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password_confirmation
  has_secure_password
end