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
        @v = User.make!
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

    should "create organization with a membership" do
      assert_difference('Organization.count') do
        assert_difference('Membership.count') do
          post :create, organization: @attributes
        end
      end

      assert assigns(:organization).has_member?(@u)
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

    # should "get membership" do
    #   get :membership, id: @o
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

    context "who is a member of the organization" do

      setup do
        without_grant do
          @o.add_member(@u)
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

      should "get membership" do
        get :membership, id: @o
        assert_response :success
      end

      should "add a member to that organization" do
        assert_difference('Membership.count') do
          post :add_member, id: @o, user: { username: @v.username }
        end

        assert_redirected_to membership_organization_path(assigns(:organization))
      end

      should "leave organization" do
        assert_difference('Membership.count', -1) do
          delete :leave, id: @o
        end

        assert_redirected_to organization_path(assigns(:organization))
      end

    end

    should "watch organization" do
      assert_difference('Watch.count') do
        post :watch, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    context "who is watching the organization" do

      setup do
        @o.add_watcher(@u)
      end

      should "unwatch organization" do
        assert_difference('Watch.count', -1) do
          delete :unwatch, id: @o
        end

        assert_redirected_to organization_path(assigns(:organization))
      end

    end

    should "star organization" do
      assert_difference('Star.count') do
        post :star, id: @o
      end

      assert_redirected_to organization_path(assigns(:organization))
    end

    context "who has starred the organization" do

      setup do
        @o.add_starrer(@u)
      end

      should "unstar organization" do
        assert_difference('Star.count', -1) do
          delete :unstar, id: @o
        end

        assert_redirected_to organization_path(assigns(:organization))
      end

    end

  end

end
