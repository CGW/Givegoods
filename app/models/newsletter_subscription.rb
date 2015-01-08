class NewsletterSubscription < ActiveRecord::Base
  belongs_to :customer
  belongs_to :charity
  belongs_to :merchant

  scope :charity, where("newsletter_subscriptions.charity_id IS NOT NULL")
  scope :merchant, where("newsletter_subscriptions.merchant_id IS NOT NULL")
  scope :site, where("newsletter_subscriptions.charity_id IS NULL AND newsletter_subscriptions.merchant_id IS NULL")

  before_save :fetch_email

  def source_type
    if charity
      :charity
    elsif merchant
      :merchant
    else
      :site
    end
  end

  def source
    if charity
      charity
    elsif merchant
      merchant
    end
  end

  def source_name
    case source_type
    when :charity then "#{charity.name}"
    when :merchant then "#{merchant.name}"
    else
      "Givegoods.org"
    end
  end

  def source_url
    case source
    when :charity then charity.website_url
    when :merchant then merchant.website_url
    else
      "/"
    end
  end

  private

  def fetch_email
    self.email ||= customer.email if customer
  end
end
