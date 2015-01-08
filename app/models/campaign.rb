class Campaign < ActiveRecord::Base
  attr_accessible :slug, :tagline, :tiers_attributes, :charity_id

  belongs_to :charity
  has_many :tiers, :order => "amount_cents ASC", :dependent => :destroy
  has_many :donations

  accepts_nested_attributes_for :tiers, :allow_destroy => true, :reject_if => proc {|attrs| attrs['id'].blank? and (attrs['amount'].blank? or attrs['amount'] == '0.00') }

  validates :charity, :slug, :tagline, 
    :presence => true

  validates :slug, 
    :uniqueness => { :case_sensitive => false, :scope => :charity_id },
    :format     => { :with => /\A[a-z0-9-]+\z/i  }

  validates :slug, :tagline, 
    :length   => { :maximum => 255 }

  scope :with_tiers, includes(:tiers)
  scope :for_charity, lambda {|charity|
    where(:charity_id => charity.id)
  }

  def name 
    "Donate to #{charity.name}" if charity
  end
end
