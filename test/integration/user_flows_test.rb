require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest

  context "the Anonymous user" do

    should "get the homepage" do
      get "/"
      assert_response :success
    end

    should "get the sign in page" do
      get "/sessions/sign_in"
      assert_response :success
    end

  end

  context "a user" do

    setup do
      without_grant do
        @u = User.make!
      end
    end

    should "not sign in with the incorrect password" do
      post_via_redirect "/sessions/sign_in", user: { username: @u.username, password: 'bad password' }
      assert_response :success
      assert_equal I18n.t(:invalid, scope: [:devise, :failure]), flash[:alert]
    end

    should "sign in with the correct password" do
      post_via_redirect "/sessions/sign_in", user: { username: @u.username, password: @u.password }
      assert_response :success
      assert_equal I18n.t(:signed_in, scope: [:devise, :sessions]), flash[:notice]
      assert_equal @u, Grant::User.current_user
    end

    should "sign in and then sign out" do
      post_via_redirect "/sessions/sign_in", user: { username: @u.username, password: @u.password }
      delete_via_redirect "/sessions/sign_out"
      assert_response :success
      assert_equal I18n.t(:signed_out, scope: [:devise, :sessions]), flash[:notice]
      assert_equal nil, Grant::User.current_user
    end

  end

  context "a user and an organization" do

    setup do
      without_grant do
        @slug = "slug"
        @o = Organization.make!(:slug => @slug)
        @u = User.make!
      end
    end

    should "get an organization's page, sign in, and then get redirected to that organization's page" do
      get "/slug"
      post_via_redirect "/users/sign_in", user: { username: @u.username, password: @u.password }
      assert_response :success
      assert_not_nil assigns(:organization)
    end

  end

end
