class Challenge < ActiveRecord::Base
  belongs_to :mission
  has_many :responses
  has_many :participants, through: :responses
  has_many :answers
  has_many :current_participants, :class_name => "User", :foreign_key => "current_challenge_id"

  validate :location_is_either_rooted_sf_or_east_bay
  validates :location,
            :question,
            :response_success,
            :response_failure,
            presence: true

  accepts_nested_attributes_for :answers, :reject_if => :all_blank, :allow_destroy => true

  def self.current
    self.all.select {|c| c.mission.current }
  end

  private
    def location_is_either_rooted_sf_or_east_bay
      return if location.blank?
      if !location.match(/rooted|SF|East Bay/)
        errors.add(:location, "must be SF, East Bay, or rooted")
      end
    end
end