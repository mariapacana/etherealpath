class Mission < ActiveRecord::Base
  has_many :challenges
  has_many :participants
  accepts_nested_attributes_for :challenges, :reject_if => :all_blank, :allow_destroy => true

  validates :title, :description, presence: true

  after_create  :associate_participants

  private
    def associate_participants
      Participant.all.each {|p| p.update_attribute(:mission_id, self.id)}
    end
end