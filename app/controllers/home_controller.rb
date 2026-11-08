class HomeController < ApplicationController
  def index
    redirect_to manage_questions_path if Current.user&.faculty? || Current.user&.admin?
  end
end
