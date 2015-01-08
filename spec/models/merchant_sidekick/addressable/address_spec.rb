require 'spec_helper'

describe MerchantSidekick::Addressable::Address do

  it { should validate_presence_of(:postal_code).with_message(/can't be blank/) }

  it "allows only valid values for country_code" do
    Country.keys.each do |country_code|
      should allow_value(country_code).for(:country_code)
    end
    should_not allow_value('UK').for(:country_code)
  end

  it "allows only valid values for province_code" do
    should allow_value(nil).for(:province_code)
    Region.keys.each do |postal_code|
      should allow_value(postal_code).for(:province_code)
    end
    should_not allow_value('Hello').for(:province_code)
  end

  describe "when address is billing" do
    subject { BillingAddress.new }

    [:street, :city, :province_code].each do |attr|
      it { should validate_presence_of(attr).with_message(/Please fill in/) }
    end
  end

  describe "when addressable is a Charity" do
    let(:charity) { mock_model('Charity') }

    before do
      subject.addressable = charity
    end

    describe "that is inactive" do
      before do 
        charity.stub(:active?).and_return(false)
      end

      [:phone, :street, :city, :province_code].each do |attr|
        it { should_not validate_presence_of(attr).with_message(/can't be blank/) }
      end
    end

    describe "that is active" do
      before do 
        charity.stub(:active?).and_return(true)
      end

      [:phone, :street, :city, :province_code].each do |attr|
        it { should validate_presence_of(attr).with_message(/can't be blank/) }
      end
    end
  end

end
