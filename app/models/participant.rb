class Participant < ActiveRecord::Base
  belongs_to :challenge
  validates :first_name, :last_name, presence: true

  before_create :set_up_code

  private
    def set_up_code
      self.code = "aaaa"
    end
end