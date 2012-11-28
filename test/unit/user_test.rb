require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "a factory user" do
    setup do
      @u = User.make!
    end
    should "be valid" do
      assert @u.valid?
    end
  end

end
