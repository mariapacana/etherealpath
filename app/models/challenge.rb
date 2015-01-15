class Challenge < ActiveRecord::Base
  belongs_to :mission
  has_many :participants
  has_many :answers

  validate :location_is_either_rooted_sf_or_east_bay
  validates :location,
            :question,
            :response_success,
            :response_failure,
            presence: true

  accepts_nested_attributes_for :answers, :reject_if => :all_blank, :allow_destroy => true

  def next
    mission.challenges.where("id > ?", id).first
  end

  def prev
    mission.challenges.where("id < ?", id).last
  end

  private
    def location_is_either_rooted_sf_or_east_bay
      return if location.blank?
      if !location.match(/rooted|SF|East Bay/)
        errors.add(:location, "must be SF, East Bay, or rooted")
      end
    end
end