class Answer < ActiveRecord::Base
  belongs_to :challenge
  validates :text, presence: true

  def matches_text(text)
    text.downcase.match(self.text.downcase) ? true : false
  end
end