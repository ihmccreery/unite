require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  context "a signed-in user" do

    setup do
      without_grant do
        sign_in @u = User.make!
      end
    end

    should "get index" do
      get :index
      assert_response :success
    end

  end

end
