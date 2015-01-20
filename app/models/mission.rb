class Mission < ActiveRecord::Base
  has_many :challenges
  has_many :participants
  has_many :god_messages
  accepts_nested_attributes_for :challenges, :reject_if => :all_blank, :allow_destroy => true

  validates :title,
            :description,
            :intro,
            :warning,
            :decline_confirmation,
            :finish_confirmation,
            :location_invite,
            :start_time,
            :completed_challenges_required,
            presence: true

  validate :start_time_is_after_today

  def current_participants
    self.participants.current
  end

  def current_participants_in_sf
    self.participants.current_and_in_sf
  end

  def current_participants_in_east_bay
    self.participants.current_and_in_east_bay
  end

  def hand_of_god(params)
    self.god_messages.create(text: params[:message],
                             location: params[:location])
    params[:participants].each do |p|
      message = p.messages.create({text: params[:message], incoming: false})
      message.send_by_sms
    end
  end

  def start
    hand_of_god(participants: self.current_participants, message: self.intro)
  end

  def hand_of_god_east_bay(message)
    hand_of_god(participants: self.current_participants_in_east_bay,
                location: "East Bay",
                message: message)
  end

  def hand_of_god_east_sf(message)
    hand_of_god(participants: self.current_participants_in_sf,
                location: "SF",
                message: message)
  end

  def last_challenge
    challenges.last
  end

  private
    def start_time_is_after_today
      return if start_time.blank?
      if start_time < DateTime.now
        errors.add(:start_time, "should be after today")
      end
    end
end