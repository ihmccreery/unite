class Organization < ActiveRecord::Base

  grant(:create, :find) { true }
  grant(:update, :destroy) { |user, organization| user && organization.has_member?(user) }

  # friendly_id uses slug
  include FriendlyId
  friendly_id :slug

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :watches, dependent: :destroy
  has_many :watchers, through: :watches, source: :user
  has_many :stars, dependent: :destroy
  has_many :starrers, through: :stars, source: :user
  attr_accessible :title, :subtitle, :description, :slug

  validates :title, :description, :slug, presence: true
  validates :slug, format: { with: /^[0-9a-z_\-]+$/ }, uniqueness: true

  # move friendly_id errors to slug
  after_validation :move_friendly_id_error_to_slug

  # move friendly_id error to slug
  def move_friendly_id_error_to_slug
    errors.add :slug, *errors.delete(:friendly_id) if errors[:friendly_id].present?
  end

  def add_member(user)
    if self.has_member?(user)
      raise Exception, "#{user.username} is already a member of #{self.title}"
    end
    self.members << user
  end

  def remove_member(user)
    unless self.has_member?(user)
      raise Exception, "#{user.username} is not a member of #{self.title}"
    end
    self.members.delete(user)
  end

  def has_member?(user)
    return self.members.include?(user)
  end

end
