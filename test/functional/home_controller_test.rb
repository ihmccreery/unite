require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  context "a signed-in factory user" do

    setup do
      sign_in @u = User.make!
    end

    should "get index" do
      get :index
      assert_response :success
    end

  end

end
