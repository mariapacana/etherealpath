class TwilioController < ApplicationController
  include TwilioHelper

  skip_before_action :verify_authenticity_token

  def receive_sms
    phone = params["From"]
    message = params["Body"]

    # Find by phone number, or find by code
    participant = Participant.find_by(phone_number: phone)
    if participant
      send_message(participant.phone_number, "So glad I found you <3")
    else
      participant = Participant.find_by(code: message)
      send_message(phone, "What's the passcode?") unless participant
    end

  end

end