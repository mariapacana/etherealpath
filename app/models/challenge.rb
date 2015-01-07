class Challenge < ActiveRecord::Base
  belongs_to :mission
  has_many :participants

  validates :question, :answer, presence: true

  def next
    mission.challenges.where("id > ?", id).first
  end

  def prev
    mission.challenges.where("id < ?", id).last
  end
end