class Watch < ActiveRecord::Base

  grant(:find) { true }
  grant(:create, :destroy) { |user, watch| user && (watch.user == user) }

  belongs_to :user
  belongs_to :organization

end
