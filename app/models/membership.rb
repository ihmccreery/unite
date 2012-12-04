class Membership < ActiveRecord::Base

  grant(:find) { true }
  grant(:create, :destroy) { |user, membership| user && (membership.user == user) }

  belongs_to :user
  belongs_to :organization

end
