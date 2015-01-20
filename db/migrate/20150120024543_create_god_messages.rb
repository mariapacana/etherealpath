class CreateGodMessages < ActiveRecord::Migration
  def change
    create_table :god_messages do |t|
      t.string :text
      t.string :location
      t.references :mission
      t.timestamps
    end
  end
end
