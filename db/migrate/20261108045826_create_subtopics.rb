class CreateSubtopics < ActiveRecord::Migration[8.0]
  def change
    create_table :subtopics do |t|
      t.references :competency, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
