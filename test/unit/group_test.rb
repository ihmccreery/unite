require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  context "all fixtures" do
    should "be valid" do
      Group.all.each do |group|
        assert group.valid?
      end
    end
  end

  context "a group" do

    setup do
      @ofa_va_fos = Group.new(name: "Obama for America Virginia Field Organizers",
                              organization: Organization.find('ofa'))
    end

    context "that is valid" do
      should "be valid" do
        assert @ofa_va_fos.valid?
      end
    end

    context "that is empty" do
      should "be invalid" do
        g = Group.new
        assert g.invalid?
        assert g.errors[:name].any?
        assert g.errors[:organization].any?
      end
    end

    context "that is a duplicate in an organiation" do
      should "be invalid" do
        @ofa_va_fos.name = "Obama for America Virginia Field Directors"
        assert @ofa_va_fos.invalid?
        assert @ofa_va_fos.errors[:name].any?
      end
    end

  end

end
