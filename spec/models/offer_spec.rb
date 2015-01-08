require 'spec_helper'

describe Offer do

  it { should belong_to(:merchant) }
  it { should have_many(:bundlings).dependent(:destroy) }
  it { should have_many(:bundles).through(:bundlings) }

  it_should_behave_like "CommonAttributes::OfferCapCents is included"
  it_should_behave_like "CommonAttributes::DiscountRate is included"

  Offer::STATUSES.each do |status|
    it { should allow_value(status).for(:status) }
  end
  it { should_not allow_value(nil).for(:status) }

  Offer::MAX_CERTIFICATES.each do |cert|
    it { should allow_value(cert).for(:max_certificates) }
  end
  it { should_not allow_value(nil).for(:max_certificates) }

  describe '#donation_value' do
    describe 'when offer_cap_cents is not set' do
      it "returns $100" do
        subject.donation_value.should eq(Money.new(10000))
      end
    end

    describe "when offer_cap_cents is > 0" do
      # offer caps $75 or greater, you donate x, you can get up to 4x back 
      describe 'and >= 7500' do
        it 'returns an offer at 4x savings with no round under $10' do
          subject.offer_cap_cents = 8000
          subject.discount_rate   = 25
          subject.donation_value.should eq(Money.new(500))
        end
        it 'returns an offer at 4x savings round down to the nearest dollar over $10' do
          subject.offer_cap_cents = 20000
          subject.discount_rate   = 25
          subject.donation_value.should eq(Money.new(1200))
        end
      end

      # offer caps less than $75, when you donate x, you can get up to 2x back
      describe 'and < 7500' do
        it 'returns an offer at 2x savings' do
          subject.offer_cap_cents = 5000
          subject.discount_rate   = 25
          subject.donation_value.should eq(Money.new(625))
        end
      end
    end
  end
end


