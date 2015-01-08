require 'spec_helper'

describe Certificate do

  it { should belong_to(:merchant) }
  it { should belong_to(:charity) }
  it { should belong_to(:customer) }

  [:merchant_id, :charity_id, :customer].each do |attr|
    it { should validate_presence_of(attr).with_message(/can't be blank/) } 
  end
  
  it_should_behave_like "CommonAttributes::OfferCapCents is included"
  it_should_behave_like "CommonAttributes::AmountCents is included"
  it_should_behave_like "CommonAttributes::DiscountRate is included"

  describe "unique fields" do
    before do
      create(:certificate)
    end

    it { should validate_uniqueness_of(:code) }
  end

  describe "after validation" do
    it "sets :code on create" do
      subject.code.should eq(nil)
      subject.valid?
      subject.code.should_not be_nil
    end

    it "does not set :code on update" do
      cert = create(:certificate)
      code = cert.code

      cert.redeem!
      cert.status.should eq('redeemed')

      cert.code.should eq(code)
    end
  end
end
