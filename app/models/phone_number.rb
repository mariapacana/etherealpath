class PhoneNumber < ActiveRecord::Base
  belongs_to :participant
  validates :number, presence: true
end