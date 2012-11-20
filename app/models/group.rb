class Group < ActiveRecord::Base

  belongs_to :organization
  attr_accessible :name, :description, :organization

  validates :name, :organization, presence: true
  validates :name, uniqueness: {scope: :organization_id}

end
