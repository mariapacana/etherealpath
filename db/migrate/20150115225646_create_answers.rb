class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :text
      t.belongs_to :challenge
      t.timestamps
    end
  end
end
