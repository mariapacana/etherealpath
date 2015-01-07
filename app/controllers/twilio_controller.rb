class TwilioController < ApplicationController
  include TwilioHelper

  skip_before_action :verify_authenticity_token

  def receive_sms
    phone = params["From"]
    message = params["Body"]

    # Get participant by phone number (if you've seen them before)
    participant = Participant.find_by(phone_number: phone)

    # Get participant by passcode, and save their number
    if (!participant)
      participant = Participant.find_by(code: message)
      participant.update_attribute(:phone_number, phone) if participant
    end

    send_message(phone, "What's the passcode?") unless participant

    # If they haven't started their mission, assign them to the first
    # challenge
    if participant.has_yet_to_start_mission
      participant.assign_to_first_challenge
      send_message(phone, participant.challenge.question)
    else
    # Otherwise, check their answer and move them along if they got it right.
      if participant.challenge.answer == message
        if participant.challenge == participant.mission.challenges.last
          send_message(phone, "You finished the game!")
        else
          participant.assign_to_next_challenge
          send_message(phone, participant.challenge.question)
        end
      else
        send_message(phone, "Sorry, wrong answer!")
      end
    end
  end
end