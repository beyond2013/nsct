class Manage::ImportsController < Manage::BaseController
  def new; end

  def create
    file = params[:file]
    return redirect_to(new_manage_import_path, alert: "Choose a CSV file.") unless file

    result = QuestionImporter.new(file).call
    if result.errors.empty?
      redirect_to manage_questions_path(status: "pending"),
                  notice: "Imported #{result.created} questions as pending review."
    else
      @errors = result.errors
      render :new, status: :unprocessable_entity
    end
  end
end
