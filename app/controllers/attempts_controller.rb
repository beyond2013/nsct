class AttemptsController < ApplicationController
  def create
    mock = Mock.active.find(params[:mock_id])
    existing = Current.user.attempts.find_by(mock: mock, submitted_at: nil)

    if existing && !existing.expired?
      return redirect_to attempt_answer_path(existing, 1), notice: "Resuming your attempt."
    end
    existing&.finish!

    result = MockBuilder.new(mock: mock, user: Current.user).call
    if result.attempt.nil?
      redirect_to mocks_path, alert: "There are no approved questions yet."
    else
      if result.shortfalls.any?
        short = result.shortfalls.map { |name, n| "#{name} (#{n} short)" }.to_sentence
        flash[:notice] = "Question bank is short in: #{short}."
      end
      redirect_to attempt_answer_path(result.attempt, 1)
    end
  end

  def show
    @attempt = Current.user.attempts.find(params[:id])
    @attempt.finish! if @attempt.expired?
    return redirect_to attempt_answer_path(@attempt, 1) unless @attempt.submitted?

    @breakdown = @attempt.competency_breakdown
    @answers = @attempt.answers.includes(:option, question: [:options, { subtopic: :competency }])
  end

  def submit
    attempt = Current.user.attempts.find(params[:id])
    attempt.finish!
    redirect_to attempt_path(attempt)
  end
end
