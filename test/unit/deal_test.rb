require 'test_helper'

class DealTest < ActiveSupport::TestCase
  should belong_to :charity
  should belong_to :merchant

  should "have amount" do
    deal = FactoryGirl.create(:deal, :amount_cents => 2500)
    assert_equal "$25.00", deal.amount.format

    deal = FactoryGirl.create(:deal, :amount => 47.25)
    assert_equal "$47.25", deal.amount.format
  end

  should "validate donation budget" do
    merchant    = merchants(:powerplant)
    merchant.offer = offers(:powerplant)
    charity     = charities(:save_the_redwoods_leage)
    customer    = FactoryGirl.create(:customer)
    certificate = Certificate.create!(:merchant => merchant, :charity => charity, :customer => customer, :amount_cents => 9900, :offer_cap_cents => 20000, :discount_rate => Certificate::DISCOUNT_RATES[0])
    deal        = Deal.new :merchant => merchant, :charity => charity, :amount_cents => 100
    assert_no_error_on deal, :amount
  end

  should "validate that merchant doesn't exceeds monthly certificates" do
    max_certificates = Offer::MAX_CERTIFICATES[0] # --> 2
    offer = offers(:books_inc)
    offer.max_certificates = max_certificates
    offer.save!
    merchant = merchants(:books_inc)
    merchant.offer = offer
    charity  = charities(:save_the_redwoods_leage)
    customer = FactoryGirl.create(:customer)

    # create n deals to exhaust available certificates
    max_certificates.times do
      deal = Deal.new :merchant => merchant, :charity => charity, :amount_cents => 100
      deal.valid?
      assert deal.valid?
      Certificate.create! :merchant => merchant, :charity => charity, :customer => customer, :amount_cents => 1000, :offer_cap_cents => 2000, :discount_rate => Certificate::DISCOUNT_RATES[0] 
    end
    # so next deal should fail
    deal = Deal.new :merchant => merchant, :charity => charity, :amount_cents => 100
    assert_error_on deal, :merchant
  end

  should "validate that merchant doesn't exceeds monthly certificates. (Bundled deals version)" do
    max_certificates = Offer::MAX_CERTIFICATES[1] # --> 20
    charity  = charities(:save_the_redwoods_leage)
    customer = FactoryGirl.create(:customer)

    offer1 = offers(:books_inc)
    offer2 = offers(:powerplant)
    offer1.max_certificates = max_certificates
    offer2.max_certificates = max_certificates
    offer1.save!
    offer2.save!

    bundle = Bundle.new({
      :charity_id           => charity.id,
      :status               => "active",
      :tagline              => "This stuff is bundled!"
    })
    bundle.donation_value_cents = 5000
    bundle.save!
    bundle.offers = [offer1, offer2]

    # create n deals to exhaust available certificates
    max_certificates.times do
      deal = Deal.new :bundle => bundle, :charity => charity, :amount => 1
      assert_no_error_on deal
      Certificate.create! :merchant => offer1.merchant, :charity => charity, :customer => customer, :amount => 1, :offer_cap => 2, :discount_rate => Certificate::DISCOUNT_RATES[0]
      Certificate.create! :merchant => offer2.merchant, :charity => charity, :customer => customer, :amount => 1, :offer_cap => 2, :discount_rate => Certificate::DISCOUNT_RATES[0]
    end
    # so next deal should fail
    deal = Deal.new :bundle => bundle, :charity => charity, :amount => 1
    deal.valid?
    assert_error_on deal, :bundle
    assert_equal 2, deal.errors[:bundle].size # both deal bundles has errors
  end

  should "have merchants" do
    deal = FactoryGirl.create(:deal)
    merchants = deal.merchants
    assert_not_nil merchants
    assert_equal 1, merchants.size
  end

  context "a bundle deal" do
    setup do
      @deal = FactoryGirl.create(:bundle_deal)
    end

    should "return merchants" do
      assert_not_nil @deal.merchants
    end

    context "with multiple offers" do
      setup do
        3.times { @deal.bundle.offers << FactoryGirl.create(:offer) }
      end

      should "return multiple merchants" do
        assert_equal 3, @deal.merchants.size
      end
    end
  end

  should "be sellable" do
    assert Deal.new.sellable?
  end
end
