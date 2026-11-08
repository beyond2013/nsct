class CreateCompetencies < ActiveRecord::Migration[8.0]
  def change
    create_table :competencies do |t|
      t.string :name
      t.integer :weight
      t.integer :position

      t.timestamps
    end
  end
end
