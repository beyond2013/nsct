class MockBuilder
  Result = Struct.new(:attempt, :shortfalls)

  def initialize(mock:, user:)
    @mock = mock
    @user = user
  end

  def call
    competencies = Competency.order(:position).to_a
    quotas = quotas_for(competencies)
    picked = []
    shortfalls = {}

    competencies.each do |c|
      ids = Question.approved.joins(:subtopic)
                    .where(subtopics: { competency_id: c.id }).pluck(:id)
      take = ids.sample(quotas[c.id])
      picked.concat(take)
      lack = quotas[c.id] - take.size
      shortfalls[c.name] = lack if lack.positive?
    end

    return Result.new(nil, shortfalls) if picked.empty?

    attempt = nil
    Attempt.transaction do
      attempt = Attempt.create!(user: @user, mock: @mock, started_at: Time.current)
      picked.shuffle.each.with_index(1) do |qid, pos|
        attempt.answers.create!(question_id: qid, position: pos)
      end
    end
    Result.new(attempt, shortfalls)
  end

  private

  # Largest-remainder split of total_questions by competency weight,
  # so the quotas always add up exactly to the requested total.
  def quotas_for(competencies)
    total = @mock.total_questions
    raw = competencies.to_h { |c| [c.id, total * c.weight / 100.0] }
    quotas = raw.transform_values(&:floor)
    leftover = total - quotas.values.sum
    raw.sort_by { |_, v| -(v - v.floor) }.first(leftover).each { |id, _| quotas[id] += 1 }
    quotas
  end
end
