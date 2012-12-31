class OrganizationsController < ApplicationController

  include Grant::Status

  before_filter :authenticate_user!, only: [:new, :watch, :star]

  layout 'organization', except: [:index, :new]

  # GET /organizations
  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /my_organization
  def show
    @organization = Organization.find(params[:id].downcase)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /organizations/my_organization/edit
  def edit
    @organization = Organization.find(params[:id].downcase)
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])
    success = @organization.save
    without_grant { @organization.add_member(current_user) }

    respond_to do |format|
      if success
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /my_organization
  def update
    @organization = Organization.find(params[:id].downcase)

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # GET /organizations/my_organization/delete
  def delete
    @organization = Organization.find(params[:id].downcase)
  end

  # DELETE /my_organization
  def destroy
    @organization = Organization.find(params[:id].downcase)

    if params[:organization] && (params[:organization][:title] == @organization.title) &&  (params[:organization][:slug] == @organization.slug)
      @organization.destroy
      # TODO make this more sensible, maybe based on success/failure
      respond_to do |format|
        format.html { redirect_to organizations_path, notice: 'Organization was successfully destroyed.' }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = 'Incorrect title or slug.'
          render action: "delete"
        end
      end
    end
  end

  # GET /organizations/my_organization/edit
  def membership
    @organization = Organization.find(params[:id].downcase)
  end

  # POST /organizations/my_organization/add_member
  def add_member
    @organization = Organization.find(params[:id].downcase)
    @user = User.find_by_username(params[:user][:username].downcase)
    @organization.add_member(@user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to membership_organization_path(@organization), notice: "User #{params[:user][:username]} added." }
    end
  end

  # POST /organizations/my_organization/leave
  def leave
    @organization = Organization.find(params[:id].downcase)

    unless @organization.members.reject{ |member| member == current_user }.empty?
      @organization.remove_member(current_user)
      # TODO make this more sensible, maybe based on success/failure
      respond_to do |format|
        format.html { redirect_to @organization }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = 'You are the only member of this organization, so you must either delete the organization, or transfer the organization by adding another member before leaving.'
          render action: "membership"
        end
      end
    end

  end

  # POST /organizations/my_organization/watch
  def watch
    @organization = Organization.find(params[:id].downcase)
    @organization.add_watcher(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
    end
  end

  # POST /organizations/my_organization/unwatch
  def unwatch
    @organization = Organization.find(params[:id].downcase)
    @organization.remove_watcher(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
    end
  end

  # POST /organizations/my_organization/star
  def star
    @organization = Organization.find(params[:id].downcase)
    @organization.add_starrer(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
    end
  end

  # POST /organizations/my_organization/unstar
  def unstar
    @organization = Organization.find(params[:id].downcase)
    @organization.remove_starrer(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
    end
  end

end
