class ApplicationController < ActionController::Base
  protect_from_forgery

  # for Grant
  before_filter :set_current_user

  # for Devise redirect back to page
  after_filter :store_location

  # for Grant
  private
  def set_current_user
    Grant::User.current_user = @current_user
  end

  # for Devise redirect back to page
  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_path] = request.fullpath unless request.fullpath =~ /\/sessions/
  end

  def after_sign_in_path_for(resource)
    session[:previous_path] || root_path
  end

  def after_update_path_for(resource)
    session[:previous_path] || root_path
  end

end
