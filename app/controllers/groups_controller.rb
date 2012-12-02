class GroupsController < ApplicationController
  # GET /organizations/abc/groups
  # GET /organizations/abc/groups.json
  def index
    @organization = Organization.find(params[:organization_id])
    @groups = Group.where(organization_id: @organization.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /organizations/abc/groups/1
  # GET /organizations/abc/groups/1.json
  def show
    @organization = Organization.find(params[:organization_id])
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /organizations/abc/groups/new
  # GET /organizations/abc/groups/new.json
  def new
    @organization = Organization.find(params[:organization_id])
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /organizations/abc/groups/1/edit
  def edit
    @organization = Organization.find(params[:organization_id])
    @group = Group.find(params[:id])
  end

  # POST /organizations/abc/groups
  # POST /organizations/abc/groups.json
  def create
    @organization = Organization.find(params[:organization_id])
    @group = Group.new(params[:group])
    @group.organization = @organization

    respond_to do |format|
      if @group.save
        format.html { redirect_to [@organization, @group], notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/abc/groups/1
  # PUT /organizations/abc/groups/1.json
  def update
    @organization = Organization.find(params[:organization_id])
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to [@organization, @group], notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/abc/groups/1
  # DELETE /organizations/abc/groups/1.json
  def destroy
    @organization = Organization.find(params[:organization_id])
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to organization_groups_url(@organization) }
      format.json { head :no_content }
    end
  end
end
