class Organization < ActiveRecord::Base

  attr_accessible :title, :subtitle, :description, :slug

  validates :title, :description, :slug, presence: true
  validates :slug, format: { with: /^[0-9a-zA-Z_\-]+$/ }, uniqueness: true

end
