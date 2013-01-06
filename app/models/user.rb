class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :confirmable
  # :omniauthable
  # :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  # friendly_id uses slug
  include FriendlyId
  friendly_id :username

  # Setup accessible (or protected) attributes for your model
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :watches, dependent: :destroy
  has_many :watched_organizations, through: :watches, source: :organization
  has_many :stars, dependent: :destroy
  has_many :starred_organizations, through: :stars, source: :organization
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  validates :username, presence: true, format: { with: /^[0-9a-z_\-]+$/ }, uniqueness: true

  # move friendly_id errors to slug
  after_validation :move_friendly_id_error_to_username

  # move friendly_id error to username
  def move_friendly_id_error_to_username
    errors.add :username, *errors.delete(:friendly_id) if errors[:friendly_id].present?
  end

end
