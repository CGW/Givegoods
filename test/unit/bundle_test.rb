require 'test_helper'

class BundleTest < ActiveSupport::TestCase
  should validate_presence_of(:charity_id)

  context "a bundle" do
    setup do
      @bundle = bundles(:boys_and_girls_of_alameda_with_no_offers)
    end

    should "be valid" do
      assert @bundle.valid?
    end

    should "be invalid without a donation value" do
      @bundle.donation_value_cents = nil
      assert_error_on @bundle, :donation_value_cents
    end

    should "return merchants" do
      assert_respond_to @bundle, :merchants
    end

    context "with an offer" do
      setup do
        @bundle.offers << offers(:burma_superstar)
      end

      should "be valid" do
        assert @bundle.valid?
      end

      should "be included as active" do
        assert Bundle.active.include?(@bundle)
      end

      should "return merchant" do
        assert_equal [merchants(:burma_superstar)], @bundle.merchants
      end

      context "with a second offer" do
        setup do
          @bundle.offers << offers(:blue_dot_cafe)
        end

        should "be valid" do
          assert @bundle.valid?
        end

        should "return second merchant" do
          assert @bundle.merchants.include?(merchants(:blue_dot_cafe))
        end
      end
    end

    context "with a paused offer" do
      setup do
        @bundle.offers << offers(:flowers)
      end

      should "be valid" do
        assert @bundle.valid?
      end

      should "not be included as active" do
        assert !Bundle.active.include?(@bundle)
      end

      context "with a second active offer" do
        setup do
          @bundle.offers << offers(:burma_superstar)
        end

        should "not be included as active" do
          assert !Bundle.active.include?(@bundle)
        end
      end
    end
  end
end
