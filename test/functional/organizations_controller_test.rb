require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  context "a signed-in factory user with a factory organization" do

    setup do
      without_grant do
        @o = Organization.make!
        @attributes = {title: "Some Organization",
                       slug: "so",
                       description: "We do stuff."}
        sign_in @u = User.make!
      end
    end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:organizations)
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create organization" do
      assert_difference('Organization.count') do
        post :create, organization: @attributes
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    should "show organization" do
      get :show, id: @o
      assert_response :success
    end

    # should "get edit" do
    #   get :edit, id: @o
    #   assert_response :success
    # end

    # should "update organization" do
    #   put :update, id: @o, organization: @attributes
    #   assert_redirected_to organization_path(assigns(:organization))
    # end

    # should "destroy organization" do
    #   assert_difference('Organization.count', -1) do
    #     delete :destroy, id: @o
    #   end

    #   assert_redirected_to organizations_path
    # end

    should "join organization" do
      assert_difference('Membership.count') do
        post :join, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    should "leave organization" do
      @o.add_member!(@u)
      assert_difference('Membership.count', -1) do
        delete :leave, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    should "watch organization" do
      assert_difference('Watch.count') do
        post :watch, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    should "unwatch organization" do
      @o.add_watcher!(@u)
      assert_difference('Watch.count', -1) do
        delete :unwatch, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    should "star organization" do
      assert_difference('Star.count') do
        post :star, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    should "unstar organization" do
      @o.add_starrer!(@u)
      assert_difference('Star.count', -1) do
        delete :unstar, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    context "who is a member of the organization" do

      setup do
        without_grant do
          @o.add_member!(@u)
        end
      end

      should "get edit" do
        get :edit, id: @o
        assert_response :success
      end

      should "update organization" do
        put :update, id: @o, organization: @attributes
        assert_redirected_to organization_path(assigns(:organization))
      end

      should "destroy organization" do
        assert_difference('Organization.count', -1) do
          delete :destroy, id: @o
        end

        assert_redirected_to organizations_path
      end

    end

  end

end
