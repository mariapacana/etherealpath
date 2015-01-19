class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :code
      t.string :current_challenge_id
      t.boolean :declined
      t.boolean :intro_accepted
      t.boolean :warning_accepted
      t.belongs_to :mission
      t.timestamps
    end
  end
end
