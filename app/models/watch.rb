class Watch < ActiveRecord::Base

  grant(:find) { true }
  grant(:create) { |user, watch| user && (watch.user == user) }
  grant(:destroy) { |user, watch| user && ((watch.user == user) || (watch.organization.has_member?(user))) }

  belongs_to :user
  belongs_to :organization

  validates :organization_id, :uniqueness => { :scope => :user_id, :message => "is already watched by user" }
  validates_presence_of :user, :organization

end
