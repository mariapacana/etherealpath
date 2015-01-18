class TwilioClient

  attr_accessor :client

  def initialize
    @client = Twilio::REST::Client.new Rails.application.secrets.TWILIO_ACCOUNT_SID, Rails.application.secrets.TWILIO_AUTH_TOKEN
    @twilio_phone = '+16506459949'
  end

  def send_message(phone, message)
    @client.messages.create from: @twilio_phone, to: phone, body: message
  end
end