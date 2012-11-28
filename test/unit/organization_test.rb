require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  context "a factory organization" do
    should "be valid" do
      assert Organization.make.valid?
    end
  end

  context "an organization" do

    setup do
      @o = Organization.make
    end

    context "that is valid" do
      should "be valid" do
        assert @o.valid?
      end
    end

    context "that is empty" do
      should "be invalid" do
        o = Organization.new
        assert o.invalid?
        assert o.errors[:title].any?
        assert o.errors[:slug].any?
        assert o.errors[:description].any?
      end
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
        @o.save!
        o = Organization.make slug: @o.slug
        assert o.invalid?
        assert o.errors[:slug].any?
      end
    end

  end

end
