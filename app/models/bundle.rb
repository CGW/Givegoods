class Bundle < ActiveRecord::Base
  belongs_to :charity

  has_many :bundlings
  has_many :offers, :through => :bundlings
  has_many :merchants, :through => :offers

  money :donation_value, :cents => :donation_value_cents
  alias price donation_value
  acts_as_sellable

  STATUSES = %w(inactive active)

  mount_uploader :image, ImageUploader

  attr_accessible :charity_id, :donation_value, :status, :name, :tagline, :notes, :image, :offer_ids,
                  :address_attributes, :remote_image_url, :image_cache, :remove_image

  validates :charity, :name, :presence => true
  validates :status, :inclusion => { :in => STATUSES }
  validates_numericality_of :donation_value_cents, :greater_than_or_equal_to => 1

  validates :name, :length => { :maximum => 100 }
  validates :tagline, :notes, :length => { :maximum => 255 }


  scope :inactive, where(:status => "inactive")

  def self.active
    where(:status => "active").find_all do |bundle|
      bundle.offers == bundle.offers.active
    end
  end

  def total_reward
    offers.sum(&:donation_value)
  end

  def total_offer_value
    offers.sum(&:offer_value)
  end

  def available_certificates?
    offers.all? { |offer| offer.merchant.available_certificates? }
  end
end
