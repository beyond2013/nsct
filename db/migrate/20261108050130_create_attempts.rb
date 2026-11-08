class CreateAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mock, null: false, foreign_key: true
      t.datetime :started_at
      t.string :submitted_at
      t.string :datetime
      t.string :score
      t.string :integer

      t.timestamps
    end
  end
end
