class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :code
      t.string :current_challenge_id
      t.belongs_to :mission
      t.timestamps
    end
  end
end
