class AddAttachmentPictureToResponses < ActiveRecord::Migration
  def self.up
    add_attachment :responses, :picture
  end

  def self.down
    remove_attachment :responses, :picture
  end
end