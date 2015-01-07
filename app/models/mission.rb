class Mission < ActiveRecord::Base
  has_many :challenges
  accepts_nested_attributes_for :challenges, :reject_if => :all_blank, :allow_destroy => true

  validates :title, :description, presence: true
  after_create :assign_participants_to_first_challenge

  private
    def assign_participants_to_first_challenge
      Participant.all.each {|p| p.update_attribute(:challenge_id, self.challenges.first.id)}
    end
end