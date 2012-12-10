class Star < ActiveRecord::Base

  grant(:find) { true }
  grant(:create, :destroy) { |user, star| user && (star.user == user) }

  belongs_to :user
  belongs_to :organization

  validates :organization_id, :uniqueness => { :scope => :user_id, :message => "is already starred by user" }

end
