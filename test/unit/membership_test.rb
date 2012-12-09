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

    should "be able to join an organization" do
      assert_nothing_raised(Grant::Error) { @o.add_member(@u) }
    end

    should "not be able to add another user to an organization" do
      assert_raise(Grant::Error) { @o.add_member(@v) }
    end

  end

  # mechanics

  context "adding a user to an organization" do

    setup do
      without_grant do
        @u = User.make!
        @o = Organization.make!
        @o.add_member(@u)
      end
    end

    should "succeed" do
      assert @o.has_member?(@u)
    end

    should "not allow the user to be added again" do
      assert_raise(Membership::Error) do
        @o.add_member(@u)
      end
    end

    context "then removing that user from that organization" do

      setup do
        without_grant do
          @o.remove_member(@u)
        end
      end

      should "remove that user from that organization" do
        assert !@o.has_member?(@u)
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
