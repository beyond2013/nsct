class CreateMocks < ActiveRecord::Migration[8.0]
  def change
    create_table :mocks do |t|
      t.string :title
      t.integer :duration_minutes
      t.integer :total_questions

      t.timestamps
    end
  end
end
