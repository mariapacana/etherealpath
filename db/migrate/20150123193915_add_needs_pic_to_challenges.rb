class AddNeedsPicToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :needs_pic, :boolean
  end
end
