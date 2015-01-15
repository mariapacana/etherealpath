class Answer < ActiveRecord::Base
  belongs_to :challenge
  validates :text, presence: true
end