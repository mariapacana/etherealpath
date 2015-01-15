class Mission < ActiveRecord::Base
  has_many :challenges
  has_many :participants
  accepts_nested_attributes_for :challenges, :reject_if => :all_blank, :allow_destroy => true

  validates :title, :description, :start_time, presence: true

  validate :start_time_is_after_today

  after_create  :associate_participants

  private
    def associate_participants
      Participant.all.each {|p| p.update_attribute(:mission_id, self.id)}
    end

    def start_time_is_after_today
      return if start_time.blank?
      if start_time < DateTime.now
        errors.add(:start_time, "should be after today")
      end
    end
end