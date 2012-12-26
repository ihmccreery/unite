class Star < ActiveRecord::Base

  grant(:find) { true }
  grant(:create) { |user, star| user && (star.user == user) }
  grant(:destroy) { |user, star| user && ((star.user == user) || (star.organization.has_member?(user))) }

  belongs_to :user
  belongs_to :organization

  validates :organization_id, :uniqueness => { :scope => :user_id, :message => "is already starred by user" }
  validates_presence_of :user, :organization

end
