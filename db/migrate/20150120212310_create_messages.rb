class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.boolean :incoming
      t.boolean :received
      t.references :participant
      t.timestamps
    end
  end
end
