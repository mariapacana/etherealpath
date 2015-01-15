class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :title
      t.string :description
      t.datetime :start_time
      t.timestamps
    end
  end
end
