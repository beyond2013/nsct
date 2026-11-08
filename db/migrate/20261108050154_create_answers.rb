class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.string :attempt
      t.string :references
      t.references :question, null: false, foreign_key: true
      t.references :option, null: true, foreign_key: true

      t.timestamps
    end
  end
end
