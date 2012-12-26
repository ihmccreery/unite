require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  context "a signed-in user with an organization" do

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

    # should "not get edit" do
    #   get :edit, id: @o
    #   assert_response :success
    # end

    should "not update organization" do
      assert_raise(Grant::Error) { put :update, id: @o, organization: @attributes }
    end

    # should "not get membership" do
    #   get :membership, id: @o
    #   assert_response :success
    # end

    should "not add a member to that organization" do
      assert_raise(Grant::Error) { post :add_member, id: @o, user: { username: @v.username } }
    end

    # should "not get delete" do
    #   get :delete, id: @o
    #   assert_response :success
    # end

    should "not destroy organization" do
      assert_raise(Grant::Error) { delete :destroy, id: @o, organization: { title: @o.title, slug: @o.slug } }
    end

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

      context "as the only member" do

        should "not leave organization" do
          assert_no_difference('Membership.count', -1) do
            delete :leave, id: @o
          end

          assert_response :success
        end

      end

      context "as not the only member" do

        setup do
          without_grant do
            @o.add_member(@v)
          end
        end

        should "leave organization" do
          assert_difference('Membership.count', -1) do
            delete :leave, id: @o
          end

          assert_redirected_to organization_path(assigns(:organization))
        end

      end

      should "get delete" do
        get :delete, id: @o
        assert_response :success
      end

      should "not destroy organization with the incorrect parameters" do
        assert_no_difference('Organization.count') do
          delete :destroy, id: @o, organization: { title: @o.title, slug: 'wrong_slug' }
        end

        assert_response :success
      end

      should "destroy organization with the correct parameters" do
        assert_difference('Organization.count', -1) do
          delete :destroy, id: @o, organization: { title: @o.title, slug: @o.slug }
        end

        assert_redirected_to root_path
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
        without_grant do
          @o.add_watcher(@u)
        end
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
        without_grant do
          @o.add_starrer(@u)
        end
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
