class OrganizationsController < ApplicationController

  include Grant::Status

  before_filter :authenticate_user!, only: [:new, :watch, :star]

  layout 'organization', except: [:index, :new, :create]

  respond_to :html

  # GET /
  def index
    @organizations = Organization.all.shuffle
  end

  # GET /my_organization
  def show
    @organization = Organization.find(params[:id].downcase)
  end

  # GET /new
  def new
    @organization = Organization.new
  end

  # POST /
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      flash[:notice] = "#{@organization.title} was successfully created."
      without_grant { @organization.add_member(current_user) }
    end
    respond_with @organization
  end

  # GET /my_organization/edit
  def edit
    @organization = Organization.find(params[:id].downcase)
  end

  # PUT /my_organization
  def update
    @organization = Organization.find(params[:id].downcase)
    if @organization.update_attributes(params[:organization])
      flash[:notice] = "#{@organization.title} was successfully updated."
    end
    respond_with @organization
  end

  # GET /my_organization/delete
  def delete
    @organization = Organization.find(params[:id].downcase)
  end

  # DELETE /my_organization
  def destroy
    @organization = Organization.find(params[:id].downcase)
    if params[:organization] && (params[:organization][:title] == @organization.title) &&  (params[:organization][:slug] == @organization.slug)
      if @organization.destroy
        flash[:notice] = "#{@organization.title} was successfully destroyed."
      end
      respond_with @organization
    else
      flash[:alert] = 'Incorrect title or slug.'
      respond_with @organization, location: delete_organization_path(@organization)
    end
  end

  # GET /my_organization/edit
  def membership
    @organization = Organization.find(params[:id].downcase)
  end

  # POST /my_organization/add_member
  def add_member
    @organization = Organization.find(params[:id].downcase)
    @user = User.find_by_username(params[:user][:username].downcase)
    if @user
      @organization.add_member(@user)
      flash[:notice] = "User #{params[:user][:username]} successfully added."
      respond_with @organization, location: membership_organization_path(@organization)
    else
      flash[:alert] = "There is no user with username #{params[:user][:username]}."
      respond_with @organization, location: membership_organization_path(@organization)
    end
  end

  # POST /my_organization/leave
  def leave
    @organization = Organization.find(params[:id].downcase)
    unless @organization.members.reject{ |member| member == current_user }.empty?
      @organization.remove_member(current_user)
      # TODO make based on success/failure
      respond_with @organization
    else
      flash[:alert] = 'You are the only member of this organization, so you must either delete the organization, or transfer the organization by adding another member before leaving.'
      respond_with @organization, location: membership_organization_path(@organization)
    end
  end

  # POST /my_organization/watch
  def watch
    @organization = Organization.find(params[:id].downcase)
    @organization.add_watcher(current_user)
    # TODO make based on success/failure
    respond_with @organization
  end

  # POST /my_organization/unwatch
  def unwatch
    @organization = Organization.find(params[:id].downcase)
    @organization.remove_watcher(current_user)
    # TODO make based on success/failure
    respond_with @organization
  end

  # POST /my_organization/star
  def star
    @organization = Organization.find(params[:id].downcase)
    @organization.add_starrer(current_user)
    # TODO make based on success/failure
    respond_with @organization
  end

  # POST /my_organization/unstar
  def unstar
    @organization = Organization.find(params[:id].downcase)
    @organization.remove_starrer(current_user)
    # TODO make based on success/failure
    respond_with @organization
  end

end
