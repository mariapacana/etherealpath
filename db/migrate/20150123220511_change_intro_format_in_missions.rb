class ChangeIntroFormatInMissions < ActiveRecord::Migration
  def change
    change_column :missions, :intro, :text
  end
end
