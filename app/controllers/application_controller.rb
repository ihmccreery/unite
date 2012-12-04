class ApplicationController < ActionController::Base
  protect_from_forgery

  # for Grant
  before_filter :set_current_user

  # for Grant
  private
  def set_current_user
    Grant::User.current_user = @current_user
  end

end
