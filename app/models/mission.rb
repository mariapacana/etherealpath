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