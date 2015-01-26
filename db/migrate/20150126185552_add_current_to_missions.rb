class AddCurrentToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :current, :boolean
  end
end
