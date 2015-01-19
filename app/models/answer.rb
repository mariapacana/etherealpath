class Answer < ActiveRecord::Base
  belongs_to :challenge
  validates :text, presence: true

  include StringHelper

  def matches(text)
    matches_text(text, self.text)
  end
end