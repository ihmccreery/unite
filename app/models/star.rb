class Star < ActiveRecord::Base

  grant(:find) { true }
  grant(:create, :destroy) { |user, star| user && (star.user == user) }

  belongs_to :user
  belongs_to :organization

end
