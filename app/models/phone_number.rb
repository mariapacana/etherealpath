class PhoneNumber < ActiveRecord::Base
  belongs_to :participant
  validates :number, presence: true
  validates_uniqueness_of :number

  def unselect_preferred
    self.update_attribute(:preferred, false)
  end
end