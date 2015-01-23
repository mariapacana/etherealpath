class TwilioController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_filter :require_login

  def receive_sms
    phone = params['From']
    client = TwilioClient.new
    participant = Participant.find_by_phone_or_code(phone_number: phone,
                                                   code: params['Body'].strip)
    client.send_message(phone, "Pssst...what's the passcode (or your Eventbrite order number?)") unless participant

    # initial script
    if participant
      message = participant.messages.create({text: params['Body'],
                                             incoming: true})
      Rails.env.development? ? message.reply_from_ether : message.delay.reply_from_ether
      else

    end

    render status: 200, json: @controller.to_json
  end
end