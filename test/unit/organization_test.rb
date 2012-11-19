require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  context "all fixtures" do
    should "be valid" do
      Organization.all.each do |organization|
        assert organization.valid?
      end
    end
  end

  context "an organization" do

    setup do
      @af = Organization.new(title: "Anti-Frack",
                             slug: "af",
                             description: "Let's not get fracked.")
    end

    context "that is valid" do
      should "be valid" do
        assert @af.valid?
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
        ['a_f', 'a-f', 'A-F'].each do |slug|
          @af.slug = slug
          assert @af.valid?, "#{slug} should be a valid slug"
        end
      end
    end

    context "with an invalid slug" do
      should "be invalid" do
        ['a f', '\af', 'a@f', ' ', 'new', 'edit'].each do |slug|
          @af.slug = slug
          assert @af.invalid?
          assert @af.errors[:slug].any?, "#{slug} should be an invalid slug"
        end
      end
    end

    context "with a duplicate slug" do
      should "be invalid" do
        @af.slug = "mommas_books"
        assert @af.invalid?
        assert @af.errors[:slug].any?
      end
    end

  end

end
