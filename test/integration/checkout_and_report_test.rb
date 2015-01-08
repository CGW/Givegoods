# coding: utf-8
require 'test_helper'

# This test run through the entire transaction loop from a user's perspective,
# from adding items to a cart, to checking out. It then also validates the
# reports generated in order to ensure that the generated report corresponds
# with the expected values for the given transaction(s).
class CheckoutAndReportTest < ActionDispatch::IntegrationTest
  def single_item_setup
    @offer    = offers(:blue_dot_cafe)
    @charity  = charities(:alameda_food_bank)
    @merchant = merchants(:blue_dot_cafe)

    @transaction_form_params = {
      "order" => {
        "with_additional_donation_amount" => "1",
          "donations" => {
            "0" => {
              "charity_id" => @charity.id,
              "amount"     => "0.00"
            }
          }
        },
        "credit_card" => {
          "type"               => "bogus",
          "number"             => "1",
          "month"              => "12",
          "year"               => "2017",
          "verification_value" => "123"
        },
        "customer" => {
          "first_name" => "Joe",
          "last_name"  => "Schmoe",
          "billing_address_attributes" => {
            "street"      => "123 Sesame St",
            "city"        => "San Francisco",
            "state_code"  => "CA",
            "postal_code" => "90111"
          },
        "email"                 => "joe@example.com",
        "communicate_with_site" => "0",
        "terms"                 => "1"
      },
      "certificate" => {
        "communicate_with_charity" => "0"
      },
    }

  end

  def bundle_setup
    @offer    = offers(:books_inc)
    @offer2   = offers(:powerplant)
    @charity  = charities(:alameda_food_bank)
    @merchant = merchants(:blue_dot_cafe)

    @bundle = Bundle.new({
      :charity_id           => @charity.id,
      :status               => "active",
      :tagline              => "This stuff is bundled!"
    })
    @bundle.donation_value_cents = 5000
    @bundle.save!

    @bundle.offers = [@offer, @offer2]
    assert_equal 2, @bundle.offers.count

    @transaction_form_params = {
      "order" => {
        "with_additional_donation_amount" => "1",
          "donations" => {
            "0" => {
              "charity_id" => @charity.id,
              "amount"     => "0.00"
            }
          }
        },
        "credit_card" => {
          "type"               => "bogus",
          "number"             => "1",
          "month"              => "12",
          "year"               => "2017",
          "verification_value" => "123"
        },
        "customer" => {
          "first_name" => "Joe",
          "last_name"  => "Schmoe",
          "billing_address_attributes" => {
            "street"      => "123 Sesame St",
            "city"        => "San Francisco",
            "state_code"  => "CA",
            "postal_code" => "90111"
          },
        "email"                 => "joe@example.com",
        "communicate_with_site" => "0",
        "terms"                 => "1"
      },
      "certificate" => {
        "communicate_with_charity" => "0"
      },
    }

  end

  def run_all_steps(options = {})
    get charities_url
    assert_response :ok

    get charity_merchants_url charity_id: @charity.to_param
    assert_response :ok

    if options[:bundle]
      xhr :post, charity_bundle_deals_url(charity_id: @charity.to_param, bundle_id: @bundle.to_param)
    else
      xhr :post, charity_merchant_deals_url(charity_id: @charity.to_param, merchant_id: @merchant.to_param)
    end
    assert_response :ok

    get new_order_url
    assert_response :ok

    post orders_url, @transaction_form_params
    assert_response :redirect
  end

  should "have total transaction amount for each row in report column 'total reward donation - transaction'" do
    bundle_setup
    @transaction_form_params["order"]["donations"]["0"]["amount"] = "62.97"
    run_all_steps bundle: true
    report = Report.new date_from: Date.yesterday, date_to: Date.tomorrow
    report_data = report.export_data
    assert "$112.97", report_hash(report_data[0])["$ Total Transaction"]
    assert "$50.00", report_hash(report_data[0])["Total Reward Donation - Transaction"]
  end

  should "have a report for invoices with bundled deals" do
    bundle_setup
    run_all_steps bundle: true

    report = Report.new date_from: Date.yesterday, date_to: Date.tomorrow
    report_data = report.export_data
    # Line 1:
    # {"Certificate ID"=>"6QRQXTCG",
    #  "GG Transaction ID"=>14,
    #  "Merchant Processor Transaction ID"=>"",
    #  "Transaction Date & Time (UTC)"=>Tue, 15 May 2012 15:09:36 UTC +00:00,
    #  "Transaction Date (PDT)"=>"2012-05-15",
    #  "Transaction Time (PDT)"=>"08:09:36",
    #  "$ Total Transaction"=>"$50.00",
    #  "$GG Fee"=>"$4.00",
    #  "Reward/Tax Deduction Y/N"=>"N",
    #  "Bundle ID"=>9,
    #  "Customer ID"=>49,
    #  "Customer Email"=>"joe@example.com",
    #  "Customer Address"=>"123 Sesame St",
    #  "Customer City"=>"San Francisco",
    #  "Customer State"=>"CA",
    #  "Customer Zipcode"=>"90111",
    #  "Charity ID"=>4,
    #  "Charity Name"=>"Alameda Food Bank",
    #  "Merchant ID"=>6,
    #  "Merchant Name"=>"Powerplant LLC",
    #  "$ offer cap for certificate"=>"$30.00",
    #  "% discount rate for certificate"=>"25.00%",
    #  "$Donation \"List Price\""=>"$5.00",
    #  "Terms/Conditions for certificate"=>
    #   "Valid only for 500 kilowatt hours or more",
    #  "Tag line for certificate"=>"This stuff is bundled!",
    #  "$Tax Deductible Donation"=>"",
    #  "$Reward Donation - Bundle"=>"$50.00",
    #  "Total Reward Donation - Transaction"=>"$50.00"}

    # Line 2:
    # {"Certificate ID"=>"RWU7NATU",
    #  "GG Transaction ID"=>13,
    #  "Merchant Processor Transaction ID"=>"",
    #  "Transaction Date & Time (UTC)"=>Tue, 15 May 2012 15:07:44 UTC +00:00,
    #  "Transaction Date (PDT)"=>"2012-05-15",
    #  "Transaction Time (PDT)"=>"08:07:44",
    #  "$ Total Transaction"=>"$50.00",
    #  "$GG Fee"=>"$4.00",
    #  "Reward/Tax Deduction Y/N"=>"N",
    #  "Bundle ID"=>8,
    #  "Customer ID"=>48,
    #  "Customer Email"=>"joe@example.com",
    #  "Customer Address"=>"123 Sesame St",
    #  "Customer City"=>"San Francisco",
    #  "Customer State"=>"CA",
    #  "Customer Zipcode"=>"90111",
    #  "Charity ID"=>4,
    #  "Charity Name"=>"Alameda Food Bank",
    #  "Merchant ID"=>1,
    #  "Merchant Name"=>"Books Inc.",
    #  "$ offer cap for certificate"=>"$30.00",
    #  "% discount rate for certificate"=>"25.00%",
    #  "$Donation \"List Price\""=>"$5.00",
    #  "Terms/Conditions for certificate"=>"Not valid on Paulo Coelho books.",
    #  "Tag line for certificate"=>"This stuff is bundled!",
    #  "$Tax Deductible Donation"=>"",
    #  "$Reward Donation - Bundle"=>"$50.00",
    #  "Total Reward Donation - Transaction"=>"$50.00"}

    # MerchantSidekick::PurchaseOrder.destroy_all
    # report_data.each_with_index do |line, index|
    #   puts "---- Line #{index.next} ------"
    #   pp Hash[report_headers.zip(line)]
    #   puts "------------------------------"
    # end

    assert_equal 2, report_data.count
    assert report_hash(report_data[0])["$Reward Donation - Bundle"].present?
    assert report_hash(report_data[1])["$Reward Donation - Bundle"].present?
  end

  should "not modify certain report fields when changed in the offer" do
    single_item_setup

    run_all_steps

    @offer.offer_cap     = 99
    @offer.discount_rate = 25
    @offer.rules         = 'foobar'
    @offer.tagline       = 'barfoo'
    @offer.save!

    report = Report.new date_from: Date.yesterday, date_to: Date.tomorrow
    report_data = report.export_data
    hash = report_hash(report_data[0])

    # This offer falls under the 4x rule
    assert_equal "$500.00",                   hash["$ offer cap for certificate"]
    assert_equal "50.00%",                    hash["% discount rate for certificate"]
    assert_equal "$62.00",                    hash['$Donation "List Price"']
    assert_equal "These are the rules",       hash["Terms/Conditions for certificate"]
    assert_equal "Blue Dot Cafe is the best", hash["Tag line for certificate"]
  end

  should "not modify certain report fields when changed the bundle price" do
    bundle_setup
    run_all_steps bundle: true

    @bundle.donation_value_cents += 500
    @bundle.save!

    report = Report.new date_from: Date.yesterday, date_to: Date.tomorrow
    report_data = report.export_data

    (0..1).each do |i|
      hash = report_hash(report_data[i])
      assert_equal "$50.00", hash["$Reward Donation - Bundle"]
    end
  end

  should "have a report for invoices with single-item deals" do
    single_item_setup
    run_all_steps

    report = Report.new date_from: Date.yesterday, date_to: Date.tomorrow
    report_data = report.export_data

    expectations = {
     # "Certificate ID"                      =>"NXMUVCVM",
     # "GG Transaction ID"                   =>17,
     # "Merchant Processor Transaction ID"   =>"",
     # "Transaction Date & Time (UTC)"       =>Tue, 15 May 2012 13:33:19 UTC +00:00,
     # "Transaction Date (PDT)"              =>"2012-05-15",
     # "Transaction Time (PDT)"              =>"06:33:19",
     "$ Total Transaction"                 =>"$62.00",
     "$GG Fee"                             =>"$4.96",
     "Reward/Tax Deduction Y/N"            =>"N",
     "Bundle ID"                           =>"",
     # "Customer ID"                         =>52,
     # "Customer Email"                      =>"joe@example.com",
     # "Customer Address"                    =>"123 Sesame St",
     # "Customer City"                       =>"San Francisco",
     # "Customer State"                      =>"CA",
     # "Customer Zipcode"                    =>"90111",
     "Charity ID"                          => @charity.id,
     "Charity Name"                        => @charity.name,
     "Merchant ID"                         => @merchant.id,
     "Merchant Name"                       => @merchant.name,
     "$ offer cap for certificate"         => @offer.offer_cap.format,
     "% discount rate for certificate"     =>"%.2f\%" % @offer.discount_rate,
     # This offer falls under the 4x rule
     "$Donation \"List Price\""            =>"$62.00",
     "Terms/Conditions for certificate"    => @offer.rules,
     "Tag line for certificate"            => @offer.tagline,
     "$Tax Deductible Donation"            =>"",
     "$Reward Donation - Bundle"           =>"",
     "Total Reward Donation - Transaction" =>"$62.00"
    }

    hash = report_hash(report_data[0])

    expectations.each do |key, value|
      assert_equal hash[key], expectations[key], "bad value for #{key}"
    end

    assert report_hash(report_data[0])["$Reward Donation - Bundle"].empty?
  end

  should "have a report for invoices with multiple deals and additional donation amount" do
    bundle_setup

    @transaction_form_params["order"]["donations"]["0"]["amount"] = "62.97"

    offer3 = offers(:blue_dot_cafe)

    get charities_url
    assert_response :ok

    get charity_merchants_url charity_id: @charity.to_param
    assert_response :ok

    xhr :post, charity_bundle_deals_url(charity_id: @charity.to_param, bundle_id: @bundle.to_param)
    assert_response :ok
    xhr :post, charity_merchant_deals_url(charity_id: @charity.to_param, merchant_id: offer3.merchant.to_param)
    assert_response :ok

    get new_order_url
    assert_response :ok

    post orders_url, @transaction_form_params
    assert_response :redirect

    report = Report.new date_from: Date.yesterday, date_to: Date.tomorrow
    report_data = report.export_data

    assert_equal 4, report_data.count
    assert "$362.97", report_hash(report_data[0])["$ Total Transaction"]
    assert "$300.00", report_hash(report_data[0])["Total Reward Donation - Transaction"]

    assert_equal @bundle.id, report_hash(report_data[0])["Bundle ID"]
    assert_equal @bundle.id, report_hash(report_data[1])["Bundle ID"]
    assert_empty report_hash(report_data[2])["Bundle ID"]
    assert_empty report_hash(report_data[3])["Bundle ID"]
  end

  def report_hash(array)
    report_headers = Report.export_headers
    Hash[report_headers.zip(array)]
  end
end
