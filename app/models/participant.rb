class Participant < ActiveRecord::Base
  belongs_to :mission
  has_many :messages
  has_many :responses
  has_many :challenges, through: :responses
  belongs_to :current_challenge, class_name: "Challenge", :foreign_key => "current_challenge_id"
  has_many :phone_numbers

  validates :first_name, :last_name, presence: true

  scope :current, -> { where(declined: [nil, false]) }
  scope :not_current, -> { where(declined: true) }
  scope :needs_help, -> { where(needs_help: true) }

  include StringHelper

  def self.find_by_phone_or_code(params)
    participant = nil
    if phone_number = PhoneNumber.find_by(number: params[:phone_number])
      participant = Participant.find(phone_number.participant_id)
    end
    unless participant
      participant = Participant.find_by(code: params[:code])
      participant.create_preferred_phone_number(params[:phone_number]) if participant
    end
    participant
  end

  # Create and prefer a phone number
  def create_preferred_phone_number(number)
    self.phone_numbers.each {|p| p.unselect_preferred }
    self.phone_numbers.create(number: number, preferred: true)
  end

  def preferred_number
    self.phone_numbers.select {|n| n.preferred }.first
  end

  # Flag for help
  def toggle_help
    if self.needs_help
      self.unflag_for_help
      self.confirm_participation if self.participation_unconfirmed
      messages = []
      if self.participant.unassigned_to_a_challenge
        messages.push(self.mission.location_invite)
      else
        messages.push(self.current_challenge.question)
      end
      messages = break_strings_on_octothorpes(messages)
      messages.each do |m|
        m = self.messages.create({text: m, incoming: false })
        m.delay.send_by_sms
      end
    else
      self.flag_for_help
    end
  end

  def flag_for_help
    self.update_attribute(:needs_help, true)
  end

  def unflag_for_help
    self.update_attribute(:needs_help, false)
  end

  # Messages
  def last_message_sent
    self.messages.order(created_at: :desc).where(incoming: true).limit(1)[0]
  end

  def message_history
    self.messages.order(created_at: :desc).select {|m| m.valid? }
  end

  # Hand of God

  def self.current_and_on_challenge(challenge)
    self.current.select {|e| e.current_challenge == challenge}
  end

  def self.current_and_in_sf
    self.current.select {|e| e.in_sf }
  end

  def self.current_and_in_east_bay
    self.current.select {|e| e.in_east_bay }
  end

  def in_east_bay
    self.current_challenge.location == "East Bay"
  end

  def in_sf
    self.current_challenge.location == "SF"
  end

  def assign_to_challenge(challenge)
    self.update_attribute(:current_challenge_id, challenge.id)
  end

  def assign_to_mission(mission)
    self.update_attribute(:mission_id, mission.id)
  end

  def not_on_a_mission?
    !self.mission
  end

  def unassigned_to_a_challenge
    !self.current_challenge
  end

  def unassign_from_challenge
    self.update_attribute(:current_challenge, nil)
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

  def confirm_participation
    self.update_attribute(:intro_accepted, true) unless self.intro_accepted
    self.update_attribute(:warning_accepted, true) unless self.warning_accepted
  end

  def confirm_interest(response)
    if self.has_accepted_neither_intro_nor_warning
      if is_yes(response)
        self.update_attribute(:intro_accepted, true)
        message = self.mission.warning
      else
        self.update_attribute(:intro_accepted, false)
        self.update_attribute(:declined, true)
        message = self.mission.decline_confirmation
      end
    elsif self.has_accepted_only_intro
      if is_no(response)
        self.update_attribute(:warning_accepted, false)
        self.update_attribute(:declined, true)
        message = self.mission.decline_confirmation
      else
        self.update_attribute(:warning_accepted, true)
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

  def check_response(params)
    response = Response.create(text: params[:text],
                               picture: params[:picture_remote_url],
                               challenge: self.current_challenge,
                               participant: self)
    messages = params[:replies]
    if response.is_correct?
      response.mark_correct
      if self.finished_mission?
        messages.push(self.mission.finish_confirmation)
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

end