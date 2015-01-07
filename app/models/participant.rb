class Participant < ActiveRecord::Base
  belongs_to :mission
  belongs_to :challenge
  validates :first_name, :last_name, presence: true

  before_create :set_up_code

  def has_yet_to_start_mission
    self.mission && !self.challenge
  end

  def assign_to_first_challenge
    self.update_attribute(:challenge_id, self.mission.challenges.first.id)
  end

  def assign_to_next_challenge
    self.update_attribute(:challenge_id, challenge.next.id)
  end

  private
    def set_up_code
      self.code = "aaaa" unless self.code
    end
end