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
    session[:previous_urls] ||= []
    # store unique urls only
    session[:previous_urls].prepend request.fullpath if session[:previous_urls].first != request.fullpath
    session[:previous_urls].pop if session[:previous_urls].count > 2
  end

  # for Devise redirect back to page
  def after_sign_in_path_for(resource)
    session[:previous_urls].last || root_path
  end

end
