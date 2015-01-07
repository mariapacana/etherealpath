class Mission < ActiveRecord::Base
  has_many :challenges
  accepts_nested_attributes_for :challenges, :reject_if => :all_blank, :allow_destroy => true

  validates :title, :description, presence: true
end