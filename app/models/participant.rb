class Participant < ActiveRecord::Base
  belongs_to :mission
  has_many :responses
  has_many :challenges, through: :responses
  belongs_to :current_challenge, class_name: "Challenge", :foreign_key => "current_challenge_id"
  has_many :phone_numbers

  validates :first_name, :last_name, presence: true

  def self.find_by_name_or_code(params = {})
    if phone_number = PhoneNumber.find_by(number: params[:phone])
      participant = phone_number.participant
    end

    unless participant
      participant = Participant.find_by(code: params[:code])
      participant.phone_numbers.create(number: params[:phone]) if participant
    end
    participant
  end

  def assign_to_challenge(challenge)
    self.current_challenge = challenge
  end

  def assign_to_mission(mission)
    self.mission = mission
  end

  def not_on_a_mission?
    !self.mission
  end

  def unassigned_to_a_challenge
    !self.current_challenge
  end

  def unassign_from_challenge
    self.current_challenge = nil
  end

  #   Deciding what challenge to assign

  def completed_challenges
    challenges = self.responses.where({correct: true}).map {|r| r.challenge }
    challenges.reject {|c| c.mission != self.mission }
  end

  def uncompleted_challenges
    self.mission.challenges - self.completed_challenges
  end

  def next_challenge(location)
    self.uncompleted_challenges.reject {|c| c.location != location}[0]
  end

  def assign_to_next_challenge(location)
    self.assign_to_challenge(self.next_challenge(location))
  end

  # When deciding the next message to send
  def next_messages(params)
    messages = []
    if self.unassigned_to_a_challenge
      self.assign_to_next_challenge(params[:response_text])
      messages.push(self.current_challenge.question)
    else
      response = Response.new(text: params[:response_text])
      response.challenge = current_challenge
      response.participant = self
      if (response.is_correct?)
        response.mark_correct
        if self.uncompleted_challenges().empty?
          messages.push("Congratulations, you finished!")
        else
          messages.push(response.challenge.response_success)
          messages.push("Where would you like to go next (SF, East Bay, home?)")
          self.unassign_from_challenge
        end
      else
        messages.push(current_challenge.response_failure || "Sorry, wrong answer!")
      end
    end
    messages
  end
end