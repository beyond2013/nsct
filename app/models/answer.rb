class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :attempt
  belongs_to :option, optional: true

  validate :option_belongs_to_question

  def correct?
    option&.correct? || false
  end

  private

    def option_belongs_to_question
      return unless option && option.question_id != question_id
      errors.add(:option, "does not belong to this question")
    end
  
end
