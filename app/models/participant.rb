class Participant < ActiveRecord::Base
  belongs_to :mission
  has_many :responses
  has_many :challenges, through: :responses
  belongs_to :current_challenge, class_name: "Challenge", :foreign_key => "current_challenge_id"
  has_many :phone_numbers

  validates :first_name, :last_name, presence: true

  include StringHelper

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


   # Confirming interest

  def participation_unconfirmed
    !warning_accepted || !intro_accepted
  end

  def has_accepted_neither_intro_nor_warning
    !warning_accepted && !intro_accepted
  end

  def has_accepted_only_intro
    !warning_accepted && intro_accepted
  end

  def confirm_interest(response)
    if self.has_accepted_neither_intro_nor_warning
      if matches_text(response, "Yes")
        self.intro_accepted = true
        message = self.mission.warning
      else
        self.intro_accepted = false
        self.declined = true
        message = self.mission.decline_confirmation
      end
    elsif self.has_accepted_only_intro
      if matches_text(response, "No")
        self.warning_accepted = false
        self.declined = true
        message = self.mission.decline_confirmation
      else
        self.warning_accepted = true
        message = self.mission.location_invite
      end
    end
    message
  end

  # Assigning challenges

  def completed_challenges
    challenges = self.responses.where({correct: true}).map {|r| r.challenge }
    challenges.reject {|c| c.mission != self.mission }
  end

  def uncompleted_challenges
    self.mission.challenges - self.completed_challenges
  end

  def next_challenge(location)
    self.uncompleted_challenges.reject {|c| !matches_text(location, c.location) }[0]
  end

  def assign_to_next_challenge(location)
    self.assign_to_challenge(self.next_challenge(location))
  end

  def assign_to_last_challenge
    self.assign_to_challenge(self.mission.last_challenge)
  end

  # Checking responses

  def completed_challenges_required
    self.mission.completed_challenges_required
  end

  def finished_mission?
    self.completed_challenges.length == self.completed_challenges_required
  end

  def should_be_sent_to_last_challenge?
    self.completed_challenges.length == self.completed_challenges_required - 1
  end

  def finished_the_last_challenge?
    self.completed_challenges.include?(self.mission.last_challenge)
  end

  def check_response(response, messages)
    response = Response.create_with_associations(response_text: response,
    challenge: self.current_challenge, participant: self)
    if response.is_correct?
      response.mark_correct
      if self.finished_mission?
        messages.push("Congratulations, you finished!")
      elsif self.should_be_sent_to_last_challenge?
        messages.push(response.challenge.response_success)
        self.unassign_from_challenge
        self.assign_to_last_challenge
        messages.push(self.current_challenge.question)
      else # Move them along to the next challenge
        messages.push(response.challenge.response_success)
        messages.push(self.mission.location_invite)
        self.unassign_from_challenge
      end
    else
      messages.push(current_challenge.response_failure || "Sorry, wrong answer!")
    end
  end

  # When deciding the next message to send
  def next_messages(params)
    messages = []
    if self.participation_unconfirmed
      messages.push(self.confirm_interest(params[:response_text]))
    # Participation confirmed
    else
      # Participant is selecting a location
      if self.unassigned_to_a_challenge
        self.assign_to_next_challenge(params[:response_text])
        messages.push(self.current_challenge.question)
      else
        # Participant is sending a response
        self.check_response(params[:response_text], messages)
      end
    end
    messages
  end
end