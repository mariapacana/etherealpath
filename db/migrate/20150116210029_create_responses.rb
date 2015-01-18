class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :text
      t.boolean :correct
      t.references :participant
      t.references :challenge
    end
  end
end
