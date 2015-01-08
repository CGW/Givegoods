# encoding: UTF-8
require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  # should validate_acceptance_of :tax_deductible

  setup do
    @merchant = FactoryGirl.create(:merchant)
    @charity  = FactoryGirl.create(:charity)
    @customer = FactoryGirl.create(:customer)
  end

  should "have amount" do
    certificate = FactoryGirl.create(:certificate, :amount_cents => 495)
    assert_equal "$4.95", certificate.amount.format

    certificate = FactoryGirl.create(:certificate, :amount => 8.99)
    assert_equal "$8.99", certificate.amount.format
  end

  should "create as admin" do
    Certificate.create!({
      :merchant     => @merchant,
      :charity      => @charity,
      :customer     => @customer,
      :communicate_with_charity => "1",
      :communicate_with_merchant => "1",
      :amount_cents => 500,
      :offer_cap_cents => 1000,
      :discount_rate => Certificate::DISCOUNT_RATES[0]
    }, :as => :admin)
  end

  should "validate amount range" do
    min = Certificate.new(:amount_cents => 99)
    assert_error_on min, :amount
    max = Certificate.new(:amount_cents => 50001)
    assert_error_on max, :amount
  end

  should "build newsletter subscriptions" do
    assert_difference "NewsletterSubscription.count", 2 do
      certificate = FactoryGirl.create(:certificate, {
        :communicate_with_charity  => "1",
        :communicate_with_merchant => "1"
      })
    end
  end

  protected

  def valid_credit_card_attributes(attributes = {})
    {
      :number             => "1", #"4242424242424242",
      :first_name         => "Claudio",
      :last_name          => "Almende",
      :month              => "8",
      :year               => "#{ Time.now.year + 1 }",
      :verification_value => '123',
      :type               => 'visa'
    }.merge(attributes)
  end
end
