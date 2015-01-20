class Message < ActiveRecord::Base
  belongs_to :participant
  validates :text,
            presence: true

  def reply_from_ether
    self.replies_from_ether.each do |reply|
      reply_message = self.participant.messages.create({text: reply,
                                                        incoming: false})
      reply_message.send_by_sms
    end
  end

  def replies_from_ether
    replies = []
    if self.participant.participation_unconfirmed
      replies.push(self.participant.confirm_interest(self.text))
    # Participation confirmed
    else
      # Participant is selecting a location
      if self.participant.unassigned_to_a_challenge
        self.participant.assign_to_next_challenge(self.text)
        replies.push(self.participant.current_challenge.question)
      else
        # Participant is sending a response
        self.participant.check_response(self.text, replies)
      end
    end
    replies
  end

  def send_by_sms
    client = TwilioClient.new
    client.send_message(self.participant.phone_numbers.first.number, self.text)
  end
end