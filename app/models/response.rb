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
                    :styles => { :medium => "300x300>", :thumb => "100x100>"},
                    :bucket => 'ethereal-path'

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  def picture_remote_url=(url_value)
    self.picture = URI.parse(url_value)
    @avatar_remote_url = url_value
  end
end