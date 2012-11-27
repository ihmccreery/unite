require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  setup do
    @group = groups(:ofa_va_fds)
    @organization = organizations(:ofa)
    @attributes = {name: "Obama for America Virginia Field Organizers"}
  end

  test "should get index" do
    get :index, organization_id: @organization.id
    assert_response :success
    assert_not_nil assigns(:groups)
    assert_equal 1, assigns(:groups).size
  end

  test "should get new" do
    get :new, organization_id: @organization.id
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, organization_id: @organization.id, group: @attributes
    end
    assert_redirected_to organization_group_path(assigns(:organization), assigns(:group))
  end

  test "should show group" do
    get :show, organization_id: @organization.id, id: @group
    assert_response :success
  end

  test "should get edit" do
    get :edit, organization_id: @organization.id, id: @group
    assert_response :success
  end

  test "should update group" do
    put :update, organization_id: @organization.id, id: @group, group: @attributes
    assert_redirected_to organization_group_path(assigns(:organization), assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, organization_id: @organization.id, id: @group
    end
    assert_redirected_to organization_groups_path(@organization)
  end

end
