require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  should "create basic offer" do
    assert_difference "Offer.count" do
      FactoryGirl.create(:merchant) # the merchant factory creates an offer
    end
  end

  should "have an offer cap" do
    offer = FactoryGirl.create(:offer, :offer_cap => 123)
    assert_equal "$123.00", offer.offer_cap.format
  end

  context "an offer" do
    setup do
      @offer = offers(:books_inc)
    end

    context "included in a bundle" do
      setup do
        @bundle = charities(:alameda_food_bank).bundles.create! :donation_value => 1, :status => "active"
        @bundle.offers << @offer
      end

      should "return bundle" do
        assert_equal [@bundle], @offer.bundles
      end

      context "then included in a second bundle" do
        setup do
          @second_bundle = charities(:boys_and_girls_of_alameda).bundles.create! :donation_value => 1, :status => "active"
          @second_bundle.offers << @offer
        end

        should "return both bundles" do
          assert_equal [@bundle, @second_bundle], @offer.bundles
        end
      end
    end
  end
end
