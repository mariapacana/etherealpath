class AddAttachmentPictureToResponses < ActiveRecord::Migration
  def self.up
    change_table :responses do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :responses, :picture
  end
end
