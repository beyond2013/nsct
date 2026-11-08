class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :mock
  has_many :answers, -> { order(:position) }, dependent: :destroy

  def deadline
    started_at + mock.duration_minutes.minutes
  end

  def submitted?
    submitted_at.present?
  end

  def expired?
    !submitted? && Time.current >= deadline
  end

  def seconds_left
    [(deadline - Time.current).ceil, 0].max
  end

  # Scoring happens here, on the server, from the stored answer key.
  def finish!
    return if submitted?
    update!(
      submitted_at: [Time.current, deadline].min,
      score: answers.joins(:option).where(options: { correct: true }).count
    )
  end

  def percentage
    total = answers.size
    total.zero? ? 0 : (score.to_f * 100 / total).round(1)
  end

  # [[competency, correct, total], ...] in NSCT order
  def competency_breakdown
    answers.includes(:option, question: { subtopic: :competency })
           .group_by { |a| a.question.subtopic.competency }
           .map { |comp, list| [comp, list.count(&:correct?), list.size] }
           .sort_by { |comp, _, _| comp.position }
  end
end
