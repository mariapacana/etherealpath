class Response < ActiveRecord::Base
  belongs_to :participant
  belongs_to :challenge
  validates :challenge_id, :participant_id, presence: true

  has_attached_file :picture,
                    :storage => :s3,
                    :s3_credentials => {
                      :bucket => Rails.application.secrets.S3_BUCKET_NAME,
                      :access_key_id => Rails.application.secrets.AWS_ACCESS_KEY_ID,
                      :secret_access_key => Rails.application.secrets.AWS_SECRET_ACCESS_KEY},
                    :s3_permissions => :private,
                    :styles => { :medium => "300x300>", :thumb => "100x100>"},
                    :bucket => 'ethereal-path'

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  def picture_remote_url=(url_value)
    self.picture = URI.parse(url_value)
    @picture_remote_url = url_value
  end

  def mark_correct
    self.update_attribute(:correct, true)
  end

  def is_correct?
    if self.challenge.needs_pic
      return self.is_correct_for_pic_challenge?
    else
      return true if self.challenge.any_answer_acceptable
      self.challenge.answers.each do |answer|
        return true if answer.matches(self.text)
      end
    end
    false
  end

  def is_correct_for_pic_challenge?
    return true if self.picture
  end
end