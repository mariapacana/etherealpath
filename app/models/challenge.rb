class Challenge < ActiveRecord::Base
  belongs_to :mission

  validates :question, :answer, presence: true
end