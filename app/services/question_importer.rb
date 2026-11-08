require "csv"

class QuestionImporter
  Result = Struct.new(:created, :errors)
  LETTERS = %w[a b c d].freeze

  def initialize(file)
    @file = file
  end

  def call
    created = 0
    errors = []

    ActiveRecord::Base.transaction do
      rows = CSV.read(@file.path, headers: true, encoding: "bom|utf-8", header_converters: :downcase)
      rows.each.with_index(2) do |row, line|
        q, problem = build_question(row)
        if problem
          errors << "Line #{line}: #{problem}"
        elsif q.save
          created += 1
        else
          errors << "Line #{line}: #{q.errors.full_messages.to_sentence}"
        end
      end
      raise ActiveRecord::Rollback if errors.any?
    end

    Result.new(errors.any? ? 0 : created, errors)
  rescue CSV::MalformedCSVError => e
    Result.new(0, ["Could not read the file: #{e.message}"])
  end

  private

  def build_question(row)
    sub = Subtopic.joins(:competency).find_by(
      "LOWER(competencies.name) = ? AND LOWER(subtopics.name) = ?",
      row["competency"].to_s.strip.downcase, row["subtopic"].to_s.strip.downcase
    )
    return [nil, "unknown competency/subtopic"] unless sub

    difficulty = (row["difficulty"].presence || "medium").strip.downcase
    return [nil, "difficulty must be easy, medium or hard"] unless Question.difficulties.key?(difficulty)

    correct = row["correct"].to_s.strip.downcase
    return [nil, "correct must be one of A, B, C, D"] unless LETTERS.include?(correct)

    q = Question.new(subtopic: sub, body: row["question"].to_s.strip,
                     explanation: row["explanation"], difficulty: difficulty, status: :pending)
    LETTERS.each do |l|
      text = row["option_#{l}"].to_s.strip
      q.options.build(body: text, correct: l == correct) if text.present?
    end
    return [nil, "needs at least two options"] if q.options.size < 2
    return [nil, "the correct letter points to an empty option"] unless q.options.any?(&:correct)

    [q, nil]
  end
end
