class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :watches, dependent: :destroy
  has_many :watched_organizations, through: :watches, source: :organization
  has_many :stars, dependent: :destroy
  has_many :starred_organizations, through: :stars, source: :organization
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  validates :username, presence: true, format: { with: /^[0-9a-z_\-]+$/ }, uniqueness: true

  def join(organization)
    if self.member_of?(organization)
      raise Exception, "#{self.username} is already a member of #{organization.title}"
    end
    self.organizations << organization
  end

  def leave(organization)
    unless self.member_of?(organization)
      raise Exception, "#{self.username} is not a member of #{organization.title}"
    end
    self.organizations.delete(organization)
  end

  def member_of?(organization)
    return self.organizations.include?(organization)
  end

  def watch(organization)
    if self.is_watching?(organization)
      raise Exception, "#{self.username} is already watching #{organization.title}"
    end
    self.watched_organizations << organization
  end

  def unwatch(organization)
    unless self.is_watching?(organization)
      raise Exception, "#{self.username} is not watching #{organization.title}"
    end
    self.watched_organizations.delete(organization)
  end

  def is_watching?(organization)
    return self.watched_organizations.include?(organization)
  end

  def star(organization)
    if self.has_starred?(organization)
      raise Exception, "#{self.username} has already starred #{organization.title}"
    end
    self.starred_organizations << organization
  end

  def unstar(organization)
    unless self.has_starred?(organization)
      raise Exception, "#{self.username} has not starred #{organization.title}"
    end
    self.starred_organizations.delete(organization)
  end

  def has_starred?(organization)
    return self.starred_organizations.include?(organization)
  end

end
