require 'test_helper'

class WatchTest < ActiveSupport::TestCase

  context "a user watching an organization" do

    setup do
      without_grant do
        @u = User.make!
        @o = Organization.make!
        @u.watch(@o)
      end
    end

    should "make that user watch that organization" do
      assert @u.is_watching?(@o)
    end

    should "not allow the user to watch that organization again" do
      # TODO should this raise something more specific?
      assert_raise(Exception) do
        @u.watch(@o)
      end
    end

    context "then unwatching that organization" do

      setup do
        without_grant do
          @u.unwatch(@o)
        end
      end

      should "remove that watch" do
        assert !@u.is_watching?(@o)
      end

    end

    context "then destroying" do

      context "the user" do

        setup do
          without_grant do
            @u.destroy
          end
        end

        should "destroy the watch" do
          assert @o.watchers.empty?
        end

      end

      context "the organization" do

        setup do
          without_grant do
            @o.destroy
          end
        end

        should "destroy the watch" do
          assert @u.watched_organizations.empty?
        end

      end

    end

  end

end
