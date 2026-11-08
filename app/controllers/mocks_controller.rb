class MocksController < ApplicationController
  def index
    # Close any attempt whose time has run out
    Current.user.attempts.where(submitted_at: nil).includes(:mock).each do |a|
      a.finish! if a.expired?
    end

    @mocks = Mock.active.order(:title)
    @in_progress = Current.user.attempts.where(submitted_at: nil).includes(:mock)
    @past = Current.user.attempts.where.not(submitted_at: nil).includes(:mock).order(submitted_at: :desc)
  end
end
