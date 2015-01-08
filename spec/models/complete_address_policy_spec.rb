require 'spec_helper'

describe CompleteAddressPolicy do
  let(:address) { double('Address') }
  subject { CompleteAddressPolicy.new(address) }

  before do
    [:phone, :street, :city, :province_code, :postal_code, :country_code].each do |attr|
      address.stub(attr).and_return(nil)
    end
  end

  describe "#complete?" do
    it "returns false" do
      subject.complete?.should be_false
    end

    describe "when all address fields are present" do
      it "returns true" do
        [:phone, :street, :city, :province_code, :postal_code, :country_code].each do |attr|
          address.stub(attr).and_return('address part')
        end
        subject.complete?.should be_true
      end
    end
  end
end

