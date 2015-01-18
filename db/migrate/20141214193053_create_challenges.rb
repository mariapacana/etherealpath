class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :location
      t.string :question
      t.string :response_success
      t.string :response_failure
      t.boolean :any_answer_acceptable
      t.belongs_to :mission
      t.timestamps
    end
  end
end
