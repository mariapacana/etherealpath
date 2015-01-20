class Mission < ActiveRecord::Base
  has_many :challenges
  has_many :participants
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

  # def hand_of_god(participants, message)
  #   client = new TwilioClient
  #   participants.each {|p| client.send_message(p.phone, message)}
  # end

  # def start
  #   hand_of_god(self.current_participants, self.intro)
  # end

  # def hand_of_god_east_bay(message)
  #   hand_of_god(self.current_participants_in_east_bay, message)
  # end

  # def hand_of_god_east_sf(message)
  #   hand_of_god(self.current_participants_in_sf, message)
  # end

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