class Message < ActiveRecord::Base
  belongs_to :participant
  validates :text,
            presence: true

  include StringHelper

  def reply_from_ether
    self.replies_from_ether.each do |reply|
      reply_message = self.participant.messages.create({text: reply,
                                                        incoming: false})
      reply_message.send_by_sms
    end
  end

  def replies_from_ether
    replies = []
    if self.is_a_cry_for_help
      self.participant.flag_for_help
      User.help_alert
      replies.push("What's the trouble, sweet thing? Be patient, and a voice may respond shortly.")
    elsif self.participant.needs_help
      User.help_alert
    elsif self.participant.participation_unconfirmed
      replies.push(self.participant.confirm_interest(self.text))
    # Participation confirmed
    else
      # Participant is selecting a location
      if self.participant.unassigned_to_a_challenge
        self.participant.assign_to_next_challenge(self.text)
        replies.push(self.participant.current_challenge.question)
      else
        # Participant is sending a response
        self.participant.check_response(response_text: self.text,
                                        picture_remote_url: self.picture_remote_url,
                                        replies: replies)
      end
    end
    break_strings_on_octothorpes(replies)
  end

  def send_by_sms
    client = TwilioClient.new
    client.send_message(self.participant.preferred_number.number, self.text)
  end

  def is_a_cry_for_help
    matches_text(self.text, "angel")
  end

end