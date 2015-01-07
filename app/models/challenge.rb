class Challenge < ActiveRecord::Base
  belongs_to :mission
  has_many :participants

  validates :question, :answer, presence: true
end