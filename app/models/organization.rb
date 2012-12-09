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

  # memberships

  def add_member(user)
    if self.has_member?(user)
      return false
    else
      self.members << user
    end
  end

  def add_member!(user)
    unless self.add_member(user)
      raise Membership::Error, "#{user.username} is already a member of #{self.title}"
    end
  end

  def remove_member(user)
    unless self.has_member?(user)
      return false
    else
      self.members.delete(user)
    end
  end

  def remove_member!(user)
    unless self.remove_member(user)
      raise Membership::Error, "#{user.username} is not a member of #{self.title}"
    end
  end

  def has_member?(user)
    return self.members.include?(user)
  end

  # watches

  def add_watcher(user)
    if self.watched_by?(user)
      return false
    else
      self.watchers << user
    end
  end

  def add_watcher!(user)
    unless self.add_watcher(user)
      raise Watch::Error, "#{user.username} is already watching #{self.title}"
    end
  end

  def remove_watcher(user)
    unless self.watched_by?(user)
      false
    else
      self.watchers.delete(user)
    end
  end

  def remove_watcher!(user)
    unless self.remove_watcher(user)
      raise Watch::Error, "#{user.username} is not watching #{self.title}"
    end
  end

  def watched_by?(user)
    return self.watchers.include?(user)
  end

  # stars

  def add_starrer(user)
    if self.starred_by?(user)
      return false
    else
      self.starrers << user
    end
  end

  def add_starrer!(user)
    unless self.add_starrer(user)
      raise Star::Error, "#{user.username} has already starred #{self.title}"
    end
  end

  def remove_starrer(user)
    unless self.starred_by?(user)
      return false
    else
      self.starrers.delete(user)
    end
  end

  def remove_starrer!(user)
    unless self.remove_starrer(user)
      raise Star::Error, "#{user.username} has not starred #{self.title}"
    end
  end

  def starred_by?(user)
    return self.starrers.include?(user)
  end

end
