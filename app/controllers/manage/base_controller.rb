class Manage::BaseController < ApplicationController
  before_action :require_staff

  private

  def require_staff
    head :forbidden unless Current.user&.faculty? || Current.user&.admin?
  end
end
