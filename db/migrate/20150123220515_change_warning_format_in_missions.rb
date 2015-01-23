class ChangeWarningFormatInMissions < ActiveRecord::Migration
  def change
    change_column :missions, :warning, :text
  end
end
