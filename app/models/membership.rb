class Membership < ActiveRecord::Base

  grant(:find) { true }
  grant(:create) { |user, membership| user && membership.organization.has_member?(user) }
  grant(:destroy) { |user, membership| user && ((membership.user == user) || (membership.organization.has_member?(user))) }

  belongs_to :user
  belongs_to :organization

  validates :organization_id, :uniqueness => { :scope => :user_id, :message => "already has member" }
  validates_presence_of :user, :organization

end
