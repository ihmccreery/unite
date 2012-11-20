class Group < ActiveRecord::Base

  belongs_to :organization
  attr_accessible :description, :name

end
