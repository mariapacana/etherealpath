class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :question
      t.string :answer
      t.belongs_to :mission
      t.timestamps
    end
  end
end
