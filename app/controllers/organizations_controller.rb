class OrganizationsController < ApplicationController

  include Grant::Status

  before_filter :authenticate_user!, only: [:new, :watch, :star]

  layout 'organization', except: [:index, :new]

  # GET /o
  # GET /o.json
  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
    end
  end

  # GET /o/1
  # GET /o/1.json
  def show
    @organization = Organization.find(params[:id].downcase)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /o/new
  # GET /o/new.json
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /o/1/edit
  def edit
    @organization = Organization.find(params[:id].downcase)
  end

  # POST /o
  # POST /o.json
  def create
    @organization = Organization.new(params[:organization])
    success = @organization.save
    without_grant { @organization.add_member(current_user) }

    respond_to do |format|
      if success
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /o/1
  # PUT /o/1.json
  def update
    @organization = Organization.find(params[:id].downcase)

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /o/1/delete
  def delete
    @organization = Organization.find(params[:id].downcase)
  end

  # DELETE /o/1
  # DELETE /o/1.json
  def destroy
    @organization = Organization.find(params[:id].downcase)

    if params[:organization] && (params[:organization][:title] == @organization.title) &&  (params[:organization][:slug] == @organization.slug)
      @organization.destroy
      # TODO make this more sensible, maybe based on success/failure
      respond_to do |format|
        format.html { redirect_to organizations_path, notice: 'Organization was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = 'Incorrect title or slug.'
          render action: "delete"
        end
        format.json { head :no_content }
      end
    end
  end

  # GET /o/1/edit
  def membership
    @organization = Organization.find(params[:id].downcase)
  end

  # POST /o/1/add_member
  # POST /o/1/add_member.json
  def add_member
    @organization = Organization.find(params[:id].downcase)
    @user = User.find_by_username(params[:user][:username].downcase)
    @organization.add_member(@user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to membership_organization_path(@organization), notice: "User #{params[:user][:username]} added." }
      format.json { render json: @organization }
    end
  end

  # POST /o/1/leave
  # POST /o/1/leave.json
  def leave
    @organization = Organization.find(params[:id].downcase)

    unless @organization.members.reject{ |member| member == current_user }.empty?
      @organization.remove_member(current_user)
      # TODO make this more sensible, maybe based on success/failure
      respond_to do |format|
        format.html { redirect_to @organization }
        format.json { render json: @organization }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = 'You are the only member of this organization, so you must either delete the organization, or transfer the organization by adding another member before leaving.'
          render action: "membership"
        end
        format.json { head :no_content }
      end
    end

  end

  # POST /o/1/watch
  # POST /o/1/watch.json
  def watch
    @organization = Organization.find(params[:id].downcase)
    @organization.add_watcher(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
      format.json { render json: @organization }
    end
  end

  # POST /o/1/unwatch
  # POST /o/1/unwatch.json
  def unwatch
    @organization = Organization.find(params[:id].downcase)
    @organization.remove_watcher(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
      format.json { render json: @organization }
    end
  end

  # POST /o/1/star
  # POST /o/1/star.json
  def star
    @organization = Organization.find(params[:id].downcase)
    @organization.add_starrer(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
      format.json { render json: @organization }
    end
  end

  # POST /o/1/unstar
  # POST /o/1/unstar.json
  def unstar
    @organization = Organization.find(params[:id].downcase)
    @organization.remove_starrer(current_user)

    # TODO make this more sensible, maybe based on success/failure
    respond_to do |format|
      format.html { redirect_to @organization }
      format.json { render json: @organization }
    end
  end

end
