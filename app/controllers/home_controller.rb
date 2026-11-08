class HomeController < ApplicationController
  def index
    redirect_to(Current.user.student?  ? mocks_path : manage_questions_path)
  end
end
