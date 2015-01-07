module TwilioHelper
  #TODO: phone number is hardwired in!
  def send_message(phone, message)
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '+16506459949', to: phone, body: message
  end
end