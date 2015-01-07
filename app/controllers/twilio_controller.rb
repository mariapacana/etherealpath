class TwilioController < ApplicationController
  include TwilioHelper

  skip_before_action :verify_authenticity_token

  def receive_sms
    puts params
    # find user in database, according to phone
    # if user doesn't exist, ask for the passcode
    # put users through challenges
    phone = params["From"]
    send_message(phone, "OK")
  end
end