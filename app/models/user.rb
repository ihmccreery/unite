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
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  validates :username, presence: true, format: { with: /^[0-9a-zA-Z_\-]+$/ }, uniqueness: true

  def member_of?(organization)
    return organization.has_member?(self)
  end

end
