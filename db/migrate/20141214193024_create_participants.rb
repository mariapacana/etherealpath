class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :code
      t.string :phone_number
      t.belongs_to :challenge
      t.belongs_to :mission
      t.timestamps
    end
  end
end
