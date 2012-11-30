require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  setup do
    @o = Organization.make!
    @attributes = {title: "Some Organization",
                   slug: "so",
                   description: "We do stuff."}
    sign_in @u = User.make!
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post :create, organization: @attributes
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should show organization" do
    get :show, id: @o
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @o
    assert_response :success
  end

  test "should update organization" do
    put :update, id: @o, organization: @attributes
    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @o
    end

    assert_redirected_to organizations_path
  end

  test "should join organization" do
    assert_difference('Membership.count') do
      post :join, id: @o
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should leave organization" do
    @u.join(@o)
    assert_difference('Membership.count', -1) do
      delete :leave, id: @o
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should watch organization" do
    assert_difference('Watch.count') do
      post :watch, id: @o
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should unwatch organization" do
    @u.watch(@o)
    assert_difference('Watch.count', -1) do
      delete :unwatch, id: @o
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should star organization" do
    assert_difference('Star.count') do
      post :star, id: @o
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should unstar organization" do
    @u.star(@o)
    assert_difference('Star.count', -1) do
      delete :unstar, id: @o
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

end
