class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :title
      t.string :description
      t.string :intro
      t.string :warning
      t.integer :completed_challenges_required
      t.datetime :start_time
      t.timestamps
    end
  end
end
