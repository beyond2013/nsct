class AnswersController < ApplicationController
  before_action :set_attempt
  before_action :require_open_attempt

  def show
    @answer = @attempt.answers.find_by!(position: params[:position])
    @total = @attempt.answers.size
    @answered = @attempt.answers.where.not(option_id: nil).pluck(:position)
    # Stable per-attempt shuffle of the options
    @options = @answer.question.options.sort_by(&:id).shuffle(random: Random.new(@answer.id))
  end

  def update
    answer = @attempt.answers.find_by!(position: params[:position])

    if params[:clear].present?
      answer.update!(option: nil)
    elsif params[:option_id].present?
      # Looked up through the question, so an option from another question is rejected
      answer.update!(option: answer.question.options.find(params[:option_id]))
    end

    total = @attempt.answers.size
    target = case params[:go]
             when "next" then [answer.position + 1, total].min
             when "prev" then [answer.position - 1, 1].max
             when nil, "" then answer.position
             else params[:go].to_i.clamp(1, total)
             end
    redirect_to attempt_answer_path(@attempt, target)
  end

  private

  def set_attempt
    @attempt = Current.user.attempts.find(params[:attempt_id])
  end

  def require_open_attempt
    @attempt.finish! if @attempt.expired?
    redirect_to attempt_path(@attempt), notice: "This attempt is finished." if @attempt.submitted?
  end
end
