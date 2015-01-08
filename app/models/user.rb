class User < ActiveRecord::Base
  # Devise modules. Others available are: :token_authenticatable, :encryptable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  ROLES = %w(charity merchant).freeze

  attr_accessor :terms
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :terms

  has_one :merchant, :dependent => :nullify
  has_one :charity, :dependent => :nullify

  normalize_attribute :email, :first_name, :last_name, :password, :password_confirmation

  validates :first_name, :last_name, 
    :presence => true,
    :length   => { :maximum => 255 }

  validates :terms, :acceptance => true

  validates :role, :inclusion => { :in => ROLES, :allow_nil => true }

  scope :active, where("users.confirmed_at IS NOT NULL") 
  scope :unconfirmed, where("users.confirmed_at IS NULL") 
  scope :charity, where(:role => 'charity')
  scope :merchant, where(:role => 'merchant')

  def to_s
    self.merchant ? "#{email} -> #{merchant.name}" : "#{email}"
  end

  def name
    "#{first_name} #{last_name}"
  end
end
