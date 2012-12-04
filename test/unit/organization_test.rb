require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  # security

  context "a user who is a member of an organization" do

    setup do
      without_grant do
        @o = Organization.make!
        Grant::User.current_user = @u = User.make!
        @u.join(@o)
      end
    end

    should "be able to save that organization" do
      assert_nothing_raised(Grant::Error) { @o.save }
    end

    should "be able to destroy that organization" do
      assert_nothing_raised(Grant::Error) { @o.save }
    end

  end

  context "a user who is not a member of an organization" do

    setup do
      without_grant do
        @o = Organization.make!
        Grant::User.current_user = User.make!
      end
    end

    should "not be able to save that organization" do
      assert_raise(Grant::Error) { @o.save }
    end

    should "not be able to destroy that organization" do
      assert_raise(Grant::Error) { @o.destroy }
    end

  end

  # validations

  context "an organization" do

    setup do
      without_grant do
        @o = Organization.make!
      end
    end

    should "be valid" do
      assert @o.valid?
    end

    context "with a valid slug" do
      should "be valid" do
        ['o_o', 'o-o', 'O-O'].each do |slug|
          @o.slug = slug
          assert @o.valid?, "#{slug} should be a valid slug"
        end
      end
    end

    context "with an invalid slug" do
      should "be invalid" do
        ['o o', '\o', 'o@', ' ', 'new', 'edit'].each do |slug|
          @o.slug = slug
          assert @o.invalid?
          assert @o.errors[:slug].any?, "#{slug} should be an invalid slug"
        end
      end
    end

    context "with a duplicate slug" do
      should "be invalid" do
        o = Organization.make slug: @o.slug
        assert o.invalid?
        assert o.errors[:slug].any?
      end
    end

  end

  context "an empty organization" do

    setup do
      without_grant do
        @o = Organization.new
      end
    end

    should "be invalid" do
      assert @o.invalid?
      assert @o.errors[:title].any?
      assert @o.errors[:slug].any?
      assert @o.errors[:description].any?
    end

  end

end
