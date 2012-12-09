require 'test_helper'

class WatchTest < ActiveSupport::TestCase

  # security

  context "a user" do

    setup do
      without_grant do
        @o = Organization.make!
        Grant::User.current_user = @u = User.make!
        @v = User.make!
      end
    end

    should "be able to watch an organization" do
      assert_nothing_raised(Grant::Error) { @o.add_watcher(@u) }
    end

    should "not be able to watch an organization for another user" do
      assert_raise(Grant::Error) { @o.add_watcher(@v) }
    end

  end

  # mechanics

  context "a user watching an organization" do

    setup do
      without_grant do
        @u = User.make!
        @o = Organization.make!
        @o.add_watcher(@u)
      end
    end

    should "succeed" do
      assert @o.watched_by?(@u)
    end

    should "not allow the user to watch that organization again" do
      # TODO should this raise something more specific?
      assert_raise(Exception) do
        @o.add_watcher(@u)
      end
    end

    context "then unwatching that organization" do

      setup do
        without_grant do
          @o.remove_watcher(@u)
        end
      end

      should "remove that watch" do
        assert !@o.watched_by?(@u)
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
