class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :title
      t.string :description
      t.string :intro
      t.string :warning
      t.string :decline_confirmation
      t.string :location_invite
      t.integer :completed_challenges_required
      t.datetime :start_time
      t.timestamps
    end
  end
end
