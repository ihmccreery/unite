class Watch < ActiveRecord::Base

  grant(:find) { true }
  grant(:create, :destroy) { |user, watch| user && (watch.user == user) }

  belongs_to :user
  belongs_to :organization

  validates :organization_id, :uniqueness => { :scope => :user_id, :message => "is already watched by user" }
  validates_presence_of :user, :organization

end
