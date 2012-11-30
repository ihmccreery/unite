require 'test_helper'

class StarTest < ActiveSupport::TestCase

  context "a user starring an organization" do

    setup do
      @u = User.make!
      @o = Organization.make!
      @u.star(@o)
    end

    should "make that user star that organization" do
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
        @u.unstar(@o)
      end

      should "remove that star" do
        assert !@u.has_starred?(@o)
      end

    end

    context "then destroying" do

      context "the user" do

        setup do
          @u.destroy
        end

        should "destroy the star" do
          assert @o.starrers.empty?
        end

      end

      context "the organization" do

        setup do
          @o.destroy
        end

        should "destroy the star" do
          assert @u.starred_organizations.empty?
        end

      end

    end

  end

end
