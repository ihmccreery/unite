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

end
