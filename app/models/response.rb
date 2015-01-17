class Response < ActiveRecord::Base
  belongs_to :participant
  belongs_to :challenge
  validates :text, :challenge_id, :participant_id, presence: true

  has_attached_file :picture,
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>" }

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
end