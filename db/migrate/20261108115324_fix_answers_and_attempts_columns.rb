class FixAnswersAndAttemptsColumns < ActiveRecord::Migration[8.0]
  
  def change
    # answers: stray columns from a mistyped generator command
    remove_column :answers, :attempt, :string
    remove_column :answers, :references, :string
    add_reference :answers, :attempt, null: false, foreign_key: true

    # attempts: stray columns, and wrong types for submitted_at and score
    remove_column :attempts, :datetime, :string
    remove_column :attempts, :integer, :string
    remove_column :attempts, :submitted_at, :string
    remove_column :attempts, :score, :string
    add_column :attempts, :submitted_at, :datetime
    add_column :attempts, :score, :integer
  end
end
