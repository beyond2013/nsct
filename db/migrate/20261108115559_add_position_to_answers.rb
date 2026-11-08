class AddPositionToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :position, :integer
    add_index :answers, [:attempt_id, :question_id], unique: true
    add_index :answers, [:attempt_id, :position], unique: true
  end
end
