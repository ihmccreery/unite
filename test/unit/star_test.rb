require 'test_helper'

class StarTest < ActiveSupport::TestCase

  # security

  context "a user" do

    setup do
      without_grant do
        @o = Organization.make!
        Grant::User.current_user = @u = User.make!
        @v = User.make!
      end
    end

    should "be able to star an organization" do
      assert_nothing_raised(Grant::Error) { @u.star(@o) }
    end

    should "not be able to star an organization for another user" do
      assert_raise(Grant::Error) { @v.star(@o) }
    end

  end

  # mechanics

  context "a user starring an organization" do

    setup do
      without_grant do
        @u = User.make!
        @o = Organization.make!
        @u.star(@o)
      end
    end

    should "succeed" do
      assert @u.has_starred?(@o)
    end

    should "not allow the user to star that organization again" do
      # TODO should this raise something more specific?
      assert_raise(Exception) do
        @u.star(@o)
      end
    end

    context "then unstarring that organization" do

      setup do
        without_grant do
          @u.unstar(@o)
        end
      end

      should "remove that star" do
        assert !@u.has_starred?(@o)
      end

    end

    context "then destroying" do

      context "the user" do

        setup do
          without_grant do
            @u.destroy
          end
        end

        should "destroy the star" do
          assert @o.starrers.empty?
        end

      end

      context "the organization" do

        setup do
          without_grant do
            @o.destroy
          end
        end

        should "destroy the star" do
          assert @u.starred_organizations.empty?
        end

      end

    end

  end

end
