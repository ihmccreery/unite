class Organization < ActiveRecord::Base

  # friendly_id uses slug
  include FriendlyId
  friendly_id :slug

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships
  attr_accessible :title, :subtitle, :description, :slug

  validates :title, :description, :slug, presence: true
  validates :slug, format: { with: /^[0-9a-zA-Z_\-]+$/ }, uniqueness: true

  # move friendly_id errors to slug
  after_validation :move_friendly_id_error_to_slug

  # move friendly_id error to slug
  def move_friendly_id_error_to_slug
    errors.add :slug, *errors.delete(:friendly_id) if errors[:friendly_id].present?
  end

end
