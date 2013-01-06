class UsersController < ApplicationController

  include Grant::Status

  respond_to :html

  # GET /
  def index
    @users = User.all.shuffle
  end

  # GET /my_organization
  def show
    @user = User.find(params[:id].downcase)
  end

end
