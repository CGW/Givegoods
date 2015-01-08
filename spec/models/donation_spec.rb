require 'spec_helper'

describe Donation do

  [:amount, :charity_id].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should_not allow_mass_assignment_of(:campaign_id) }

  it { should belong_to(:order) }
  it { should belong_to(:charity) }
  it { should belong_to(:campaign) }

  [:order, :charity].each do |attr|
    it { should validate_presence_of(attr).with_message(/can't be blank/) }
  end

  include_examples "money attribute validations", :amount, 1, 10000
  # Test the custom error message in en.yml
  it { should_not allow_value(0).for(:amount).with_message('Please specify a donation amount between $1 and $10,000') }

  describe "#successful scope" do
    it "returns donations with a succesfully completed order" do
      Donation.successful.should eq(Donation.joins(:order).where('orders.status = ?', 'approved'))
    end
  end

  describe "#price" do
    it "is an alias to amount" do
      subject.amount_cents = 50.00
      subject.amount.should eq(Money.new(50))
      subject.price.should eq(Money.new(50))
    end
  end

  describe "#title" do
    it "returns a title" do
      charity = create(:charity)
      subject.charity = charity
      subject.title.should eq("Donation to '#{charity.name}'")
    end
  end

end
