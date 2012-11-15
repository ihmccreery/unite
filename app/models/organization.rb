class Organization < ActiveRecord::Base
  attr_accessible :description, :slug, :subtitle, :title
end
