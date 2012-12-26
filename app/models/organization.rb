class Organization < ActiveRecord::Base

  grant(:create) { |user| user }
  grant(:find) { true }
  grant(:update, :destroy) { |user, organization| user && organization.has_member?(user) }

  # friendly_id uses slug
  include FriendlyId
  friendly_id :slug

  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :watches
  has_many :watchers, through: :watches, source: :user
  has_many :stars
  has_many :starrers, through: :stars, source: :user
  attr_accessible :title, :subtitle, :description, :slug

  validates :title, :description, :slug, presence: true
  validates :slug, format: { with: /^[0-9a-z_\-]+$/ }, uniqueness: true

  # move friendly_id errors to slug
  after_validation :move_friendly_id_error_to_slug

  before_destroy :destroy_user_relations

  # move friendly_id error to slug
  def move_friendly_id_error_to_slug
    errors.add :slug, *errors.delete(:friendly_id) if errors[:friendly_id].present?
  end

  # destroy user relations manually to prevent callbacks running out of order
  def destroy_user_relations
    self.stars.destroy
    self.watches.destroy
    self.memberships.destroy
  end

  # memberships

  def add_member(user)
    self.members << user
  end

  def remove_member(user)
    self.members.delete(user)
  end

  def has_member?(user)
    return self.members.include?(user)
  end

  # watches

  def add_watcher(user)
    self.watchers << user
  end

  def remove_watcher(user)
    self.watchers.delete(user)
  end

  def watched_by?(user)
    return self.watchers.include?(user)
  end

  # stars

  def add_starrer(user)
    self.starrers << user
  end

  def remove_starrer(user)
    self.starrers.delete(user)
  end

  def starred_by?(user)
    return self.starrers.include?(user)
  end

end
