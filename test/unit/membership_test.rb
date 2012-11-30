require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  context "adding a user to an organization" do

    setup do
      @u = User.make!
      @o = Organization.make!
      @o.add_member(@u)
    end

    should "add that user to that organization" do
      assert @o.has_member?(@u)
      assert @u.member_of?(@o)
    end

    should "not allow the user to be added again" do
      # TODO should this raise something more specific?
      assert_raise(Exception) do
        @o.add_member(@u)
      end
    end

    context "then removing that user from that organization" do

      setup do
        @o.remove_member(@u)
      end

      should "remove that user from that organization" do
        assert !@o.has_member?(@u)
        assert !@u.member_of?(@o)
      end

    end

    context "then destroying" do

      context "the user" do

        setup do
          @u.destroy
        end

        should "destroy the membership" do
          assert @o.members.empty?
        end

      end

      context "the organization" do

        setup do
          @o.destroy
        end

        should "destroy the membership" do
          assert @u.organizations.empty?
        end

      end

    end

  end

end
