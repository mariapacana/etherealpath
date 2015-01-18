class AddPictureRemoteUrlToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :picture_remote_url, :string
  end
end
