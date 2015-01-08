require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    MerchantSidekick::default_gateway = :bogus_gateway
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::CreditCard.require_verification_value = true

    merchants = [merchants(:books_inc), merchants(:powerplant)]
    charities = [charities(:save_the_redwoods_leage), charities(:boys_and_girls_of_alameda)]

    @deal1 = Deal.create :merchant => merchants[0], :charity => charities[0], :amount => 20.00
    @deal2 = Deal.create :merchant => merchants[1], :charity => charities[0], :amount => 40.00
    @deal3 = Deal.create :merchant => merchants[0], :charity => charities[1], :amount => 60.00
    @deals = [@deal1, @deal2, @deal3]

    @customer = FactoryGirl.create(:customer)

    @sample_cart = {
      'merchants' => [@deal1.merchant.id, @deal2.merchant.id],
      'charities' => {
        charities[0].id.to_s => {
          'name' => charities[0].name,
          'deals' => [
            { 'code' => @deal1.code, 'cents' => @deal1.amount_cents, 'name' => 'Pepe, Inc.' },
            { 'code' => @deal2.code, 'cents' => @deal2.amount_cents, 'name' => 'Books Inc.' },
          ],
        },
        charities[1].id.to_s => {
          'name' => charities[1].name,
          'deals' => [
            { 'code' => @deal3.code, 'cents' => @deal3.amount_cents, 'name' => 'Pepe, Inc.' },
          ],
        },
      },
    }
    cookies[:shopping_basket] = @sample_cart.to_json
    @certs_count = @sample_cart['charities'].map{|c| c[1]['deals'].size}.reduce(:+)
    @cart_amount = @deals.map(&:amount_cents).reduce(:+)

    ActionMailer::Base.deliveries = []
  end

  should "show New page" do
    get :new
    assert assigns(:order_items)
    assert_response :success
    assert_template "new"
  end

  should "redirect when no shopping basket found in cookies" do
    cookies[:shopping_basket] = nil
    get :new
    assert_response :redirect
  end

  should "post create" do
    assert_difference "MerchantSidekick::PurchaseOrder.count", 1, "Number of Orders created are wrong"  do
      assert_difference "MerchantSidekick::PurchaseInvoice.count", 1, "Number of Invoices created are wrong" do
        assert_difference "BillingAddress.count", 3, "Number of BillingAddresses created are wrong" do
          assert_difference "Customer.count", 1, "Number of Customers created are wrong" do
            assert_difference "Certificate.count", @certs_count, "Number of Certificates created are wrong" do

              post :create,
                "certificate"=>{"communicate_with_charity"=>"1"},
                "credit_card"=>{
                  "type"=>"bogus", "number"=>"1", "month"=>"8",
                  "year"=>"#{Time.now.year + 1}", "verification_value"=>"123"},
                "customer"=>{
                  "first_name"=>"Adam", "last_name"=>"Smith", "email"=>"asmith@example.com",
                  "terms"=>"1", "communicate_with_site"=>"1",
                  "billing_address_attributes"=>{
                    "phone"=>"415.123.1234", "street"=>"100 Balboa St.",
                    "city"=>"San Francisco", "state_code"=>"CA", "postal_code"=>"94114"}}

              assert @deals = assigns(:order_items)
              assert @certificates = assigns(:certificates)
              assert @credit_card = assigns(:credit_card)
              assert_equal "1", @credit_card.number
              assert @customer = assigns(:customer)
              # assert_equal 3, @customer.newsletter_subscriptions.count
              assert @order = assigns(:order)
              assert @payment = assigns(:payment)
              assert_equal true, @payment.success?
              assert_equal 3, @order.line_items.count
              # assert_equal @cart_amount, @order.total.cents
              assert_response :redirect
              assert_no_shopping_cart
            end
          end
        end
      end
    end

    # FIXME: repeat these for all actions sending email.
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size
    email = ActionMailer::Base.deliveries.first
    assert_equal [@customer.email], email.to
    @order.charities.each do |charity|
      assert_match Regexp.new(charity.name), email.encoded
    end
    assert_match(%r{/certificates/}, email.encoded)
  end

  should "post create with errors on invalid credit card" do
    assert_no_difference "Certificate.count" do
      post :create,
        "certificate"=>{},
        "credit_card"=>{"type"=>"bogus", "number"=>"2", "month"=>"8", "year"=>"#{Time.now.year + 1}", "verification_value"=>"123"}, "customer"=>{"first_name"=>"Adam", "last_name"=>"Smith", "email"=>"asmith@example.com", "billing_address_attributes"=>{"phone"=>"415.123.1234", "street"=>"100 Balboa St.", "city"=>"San Francisco", "state_code"=>"CA", "postal_code"=>"94114"}}
      assert @credit_card = assigns(:credit_card)
      assert_equal "2", @credit_card.number
      assert_response :success
      assert_template "new"
    end
  end

  should "post create with additional donation amount" do
    assert_difference "MerchantSidekick::PurchaseOrder.count", 1, "Number of Orders created are wrong"  do
      assert_difference "MerchantSidekick::PurchaseInvoice.count", 1, "Number of Invoices created are wrong" do
        assert_difference "BillingAddress.count", 3, "Number of BillingAddresses created are wrong" do
          assert_difference "Customer.count", 1, "Number of Customers created are wrong" do
            assert_difference "Certificate.count", @certs_count, "Number of Certificates created are wrong" do

              post :create,
                "certificate"=>{
                  "amount_cents"=>"6000",
                  "communicate_with_charity"=>"1",
                  "communicate_with_merchant"=>"1"},
                "credit_card"=>{
                  "type"=>"bogus", "number"=>"1", "month"=>"8",
                  "year"=>"#{Time.now.year + 1}", "verification_value"=>"123"},
                "customer"=>{
                  "first_name"=>"Adam", "last_name"=>"Smith", "email"=>"asmith@example.com",
                  "terms"=>"1", "communicate_with_site"=>"1",
                  "billing_address_attributes"=>{
                    "phone"=>"415.123.1234", "street"=>"100 Balboa St.",
                    "city"=>"San Francisco", "state_code"=>"CA", "postal_code"=>"94114"}}

              assert_response :redirect
              assert_no_shopping_cart
              assert @deals = assigns(:order_items)
              assert @certificates = assigns(:certificates)
              assert @credit_card = assigns(:credit_card)
              assert_equal "1", @credit_card.number
              assert @customer = assigns(:customer)
              # assert_equal 2, @customer.newsletter_subscriptions.count
              assert @order = assigns(:order)
              assert @payment = assigns(:payment)
              assert_equal true, @payment.success?
              # assert_equal 3, @order.line_items.count
              # assert_equal "$82.55", @order.total.format
            end
          end
        end
      end
    end
  end

  should "post create with a bundled deal" do
    merchant = merchants(:books_inc)
    charity = charities(:save_the_redwoods_leage)
    @bundled_deal = Deal.create :merchant => merchant, :charity => charity, :amount => 20.00
    bundle = FactoryGirl.create(:bundle)
    bundle.offers << [offers(:books_inc), offers(:powerplant)]
    @bundled_deal.bundle = bundle
    @bundled_deal.save!

    assert_difference "MerchantSidekick::PurchaseOrder.count", 1, "Number of Orders created are wrong"  do
      assert_difference "MerchantSidekick::PurchaseInvoice.count", 1, "Number of Invoices created are wrong" do
        assert_difference "BillingAddress.count", 3, "Number of BillingAddresses created are wrong" do
          assert_difference "Customer.count", 1, "Number of Customers created are wrong" do
            assert_difference "Certificate.count", @certs_count, "Number of Certificates created are wrong" do

              post :create,
                "certificate"=>{"amount_cents"=>"6000",
                  "communicate_with_charity"=>"1", "communicate_with_merchant"=>"1"},

                "credit_card"=>{"type"=>"bogus", "number"=>"1", "month"=>"8",
                  "year"=>"#{Time.now.year + 1}", "verification_value"=>"123"},

                "customer"=>{"first_name"=>"Adam", "last_name"=>"Smith", "email"=>"asmith@example.com",
                    "billing_address_attributes"=>{
                      "phone"=>"415.123.1234", "street"=>"100 Balboa St.", "city"=>"San Francisco",
                      "state_code"=>"CA", "postal_code"=>"94114"},
                      "terms"=>"1", "communicate_with_site"=>"1"}

              assert @bundled_deal = assigns(:order_items)
              assert @certificates = assigns(:certificates)
              assert @credit_card = assigns(:credit_card)
              assert_equal "1", @credit_card.number
              assert @customer = assigns(:customer)
              # assert_equal 2, @customer.newsletter_subscriptions.count
              assert @order = assigns(:order)
              assert @payment = assigns(:payment)
              assert_equal true, @payment.success?
              # assert_equal 3, @order.line_items.count
              # assert_equal "$122.30", @order.total.format
              assert_response :redirect
              assert_no_shopping_cart
            end
          end
        end
      end
    end
  end

  protected

  def assert_no_shopping_cart
    assert_nil cookies['shopping_basket']
  end
end
