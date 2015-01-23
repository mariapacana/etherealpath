class ChangeQuestionFormatInChallenges < ActiveRecord::Migration
  def change
    change_column :challenges, :question, :text
  end
end
