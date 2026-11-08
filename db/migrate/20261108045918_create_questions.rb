class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :subtopic, null: false, foreign_key: true
      t.text :body
      t.text :expalanation
      t.integer :difficulty
      t.integer :status

      t.timestamps
    end
  end
end
