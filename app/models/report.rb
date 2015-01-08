class Report < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  attr_accessible :name, :date_from, :date_to

  validates :name, :date_from, :date_to, :presence => true
  validate :valid_date_range

  class << self
    def export_headers
      [
        "Certificate ID",
        "GG Transaction ID", # Order id?
        "Merchant Processor Transaction ID",  # ID from Authorize.net

        "Transaction Date & Time (UTC)",
        "Transaction Date (PDT)",
        "Transaction Time (PDT)",

        "$ Total Transaction",
        "$GG Fee",
      #  "Transaction Status ?",

        "Reward/Tax Deduction Y/N",
        "Bundle ID",

        "Customer ID",
        "Customer Email",
        "Customer Address", "Customer City", "Customer State", "Customer Zipcode",

        "Charity ID", "Charity Name",

        "Merchant ID", "Merchant Name",

        "$ offer cap for certificate",
        "% discount rate for certificate",
        "$Donation \"List Price\"",

        "Terms/Conditions for certificate",
        "Tag line for certificate",

        "$Tax Deductible Donation",
        "$Reward Donation - Bundle",
        "Total Reward Donation - Transaction",
      ]
    end
  end

  def export_data
    data = []
    MerchantSidekick::PurchaseOrder.
          where(:created_at => date_from.beginning_of_day..date_to.end_of_day).
          approved.
          includes(:buyer => :billing_address).
          includes(:donations).
          includes(:invoices => :payments).
          includes(:line_items => :sellable).
          order('created_at ASC').
    each do |order|

      order.line_items.sort.each do |line_item|
        sellable = line_item.sellable
        transaction_ids = transaction_id(order)

        if sellable.is_a?(Deal)
          deal_certificates = order.deal_certificates(sellable)
          deal_certificates.each do |certificate|
            data << process_certificate(transaction_ids, order, certificate)
          end

        elsif sellable.is_a?(Donation)
          data << process_donation(transaction_ids, order, sellable)
        end

      end # line_items
    end # orders
    data
  end

  def export_filename
    name.parameterize('_')
  end

  private

  def valid_date_range
    if self.date_from && self.date_to && self.date_from > self.date_to
      errors.add(:date_from, "invalid date range")
    end
  end

  def charity_donation(donations, charity_id)
    donations.select{|d| d.charity_id == charity_id}.first
  end

  def process_certificate(transaction_id, order, certificate)
    customer = order.buyer
    donations = order.donations
    merchant = certificate.merchant
    deal = certificate.deal
    donation = charity_donation(donations, certificate.charity_id) # could be nil
    bundle = deal.bundle # could be nil

    [
      certificate.code,
      order.id,
      transaction_id,

      order.created_at,
      order.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%Y-%m-%d"),
      order.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%H:%M:%S"),

      order.total.format,
      (order.total * 0.08).format, # FIX ME, fixed value now
      #order.status.capitalize,

      "N",
      bundle ? bundle.id : "",

      customer.id,
      customer.email,
      customer.billing_address.street,
      customer.billing_address.city,
      customer.billing_address.state_code,
      customer.billing_address.postal_code,

      certificate.charity_id,
      certificate.charity.name,

      merchant.id, merchant.name,

      Money.new(certificate.offer_cap_cents, "USD").format,
      number_to_percentage(certificate.discount_rate, :precision => 2),
      Money.new(certificate.donation_value_cents, "USD").format,

      certificate.rules,
      certificate.tagline,

      "",

      bundle ? Money.new(certificate.deal_total_cents, "USD").format : "",
      order.deals_total_amount.format,
    ]
  end

  def process_donation(transaction_id, order, donation)
    customer = order.buyer
    donations = order.donations
    [
      "",
      order.id,
      transaction_id,

      order.created_at,
      order.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%Y-%m-%d"),
      order.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%H:%M:%S"),

      order.total.format,
      (order.total * 0.08).format, # FIX ME, fixed value now
      #order.status.capitalize,

      "Y",
      "",

      customer.id,
      customer.email,
      customer.billing_address.street,
      customer.billing_address.city,
      customer.billing_address.state_code,
      customer.billing_address.postal_code,

      donation.charity_id,
      donation.charity.name,
      "", "",

      "", "", "", "", "",

      donation.price.format,
      "",
      order.deals_total_amount.format,
    ]
  end

  def transaction_id(order)
    invoices = order.invoices
    payments = invoices.map{|i| i.payments}.flatten
    payments.map{|p| p.params["transaction_id"].to_s}.reject{|e| e.empty?}.join(',')
  end
end
