class AddPictureRemoteUrlToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :picture_remote_url, :string
  end
end
