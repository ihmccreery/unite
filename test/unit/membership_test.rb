require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

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
      assert_nothing_raised(Grant::Error) { @u.join(@o) }
    end

    should "not be able to star an organization for another user" do
      assert_raise(Grant::Error) { @v.join(@o) }
    end

  end

  # mechanics

  context "adding a user to an organization" do

    setup do
      without_grant do
        @u = User.make!
        @o = Organization.make!
        @u.join(@o)
      end
    end

    should "succeed" do
      assert @u.member_of?(@o)
    end

    should "not allow the user to be added again" do
      # TODO should this raise something more specific?
      assert_raise(Exception) do
        @u.join(@o)
      end
    end

    context "then removing that user from that organization" do

      setup do
        without_grant do
          @u.leave(@o)
        end
      end

      should "remove that user from that organization" do
        assert !@u.member_of?(@o)
      end

    end

    context "then destroying" do

      context "the user" do

        setup do
          without_grant do
            @u.destroy
          end
        end

        should "destroy the membership" do
          assert @o.members.empty?
        end

      end

      context "the organization" do

        setup do
          without_grant do
            @o.destroy
          end
        end

        should "destroy the membership" do
          assert @u.organizations.empty?
        end

      end

    end

  end

end
