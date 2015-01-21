class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password_confirmation
  has_secure_password

  def self.help_alert
    self.all.each {|u| u.help_alert }
  end

  def help_alert
    client = TwilioClient.new
    client.send_message(self.phone_number, "Someone needs help! Log into Ethereal Path now.")
  end

end