class Manage::QuestionsController < Manage::BaseController
  before_action :set_question, only: %i[edit update destroy approve]

  def index
    @questions = Question.includes(subtopic: :competency).order(created_at: :desc)
    if params[:competency_id].present?
      @questions = @questions.joins(:subtopic).where(subtopics: { competency_id: params[:competency_id] })
    end
    @questions = @questions.where(status: params[:status]) if params[:status].present?
    @questions = @questions.limit(100)
  end

  def new
    @question = Question.new
    fill_options
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to manage_questions_path, notice: "Question created."
    else
      fill_options
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    fill_options
  end

  def update
    if @question.update(question_params)
      redirect_to manage_questions_path, notice: "Question updated."
    else
      fill_options
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to manage_questions_path, notice: "Question deleted."
  end

  def approve
    @question.approved!
    redirect_back fallback_location: manage_questions_path, notice: "Approved."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def fill_options
    (4 - @question.options.size).times { @question.options.build }
  end

  def question_params
    params.require(:question).permit(
      :subtopic_id, :body, :explanation, :difficulty, :status,
      options_attributes: %i[id body correct _destroy]
    )
  end
end
