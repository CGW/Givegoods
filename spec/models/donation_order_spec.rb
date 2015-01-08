require 'spec_helper'

describe DonationOrder do
  let!(:charity)     { mock_model(Charity) }
  let!(:campaign)    { mock_model(Campaign) }
  let!(:donation)    { mock_model(Donation) }
  let!(:customer)    { mock_model(Customer, :first_name => 'Barbara', :last_name => 'Marback') }
  let!(:credit_card) { ActiveMerchant::Billing::CreditCard.new }
  let!(:order)       { double('Order') }
  let!(:payment)     { double('Payment') }
  let!(:ip)          { '127.0.0.0' }
  let!(:params)      { {:an_attribute => "with a value"} }

  it_behaves_like 'ActiveModel' 

  [:donation, :customer, :credit_card].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  [:donation, :customer, :credit_card, :charity, :campaign, :request_remote_ip].each do |attr|
    it { should validate_presence_of(attr).with_message(/can't be blank/) }
  end 

  describe "validations for child elements" do
    let(:errors)  { {:"some_attribute" => ["is wrong as sing"]} }
    before do
      subject.donation = donation
      subject.customer = customer
      subject.credit_card = credit_card
    end

    it 'has no errors for donation' do
      subject.valid?
      subject.errors[:donation].should be_empty
    end

    it 'has errors for donation when it is invalid' do
      donation.stub(:valid?).and_return(false)
      donation.stub(:errors).and_return(errors)
      subject.valid?
      subject.errors[:"donation.some_attribute"].should_not be_empty
    end

    it 'has no errors for customer' do
      subject.valid?
      subject.errors[:customer].should be_empty
    end

    it 'has errors for customer when it is invalid' do
      customer.stub(:valid?).and_return(false)
      customer.stub(:errors).and_return(errors)
      subject.valid?
      subject.errors[:"customer.some_attribute"].should_not be_empty
    end

    it 'has no errors for credit_card' do
      credit_card.stub(:valid?).and_return(true)
      subject.valid?
      subject.errors[:credit_card].should be_empty
    end

    it 'has errors for credit_card when it is invalid' do
      credit_card.stub(:valid?).and_return(false)
      credit_card.stub(:errors).and_return(errors)
      subject.valid?
      subject.errors[:"credit_card.some_attribute"].should_not be_empty
    end
  end

  describe "#initialize" do
    it "assigns valid attributes" do
      donation_order = DonationOrder.new(:donation => donation)
      donation_order.donation.should eq(donation)
    end
    it "does not assign invalid attributes" do
      lambda { DonationOrder.new(:bad_attr => 'is bad') }.should raise_error
    end
    it "initializes a new donation if none is specified" do
      Donation.stub(:new).with(no_args).and_return(donation)
      DonationOrder.new.donation.should eq(donation)
    end
    it "initializes a new customer if none is specified" do
      Customer.stub(:new).with(:billing_address_attributes => {}).and_return(customer)
      DonationOrder.new.customer.should eq(customer)
    end
    it "initializes a new credit_card if none is specified" do
      ActiveMerchant::Billing::CreditCard.stub(:new).with(no_args).and_return(credit_card)
      DonationOrder.new.credit_card.should eq(credit_card)
    end
  end

  describe "#persisted?" do
    it "returns false" do
      subject.persisted?.should eq(false)
    end
  end
  
  describe "#save" do
    before do
      donation.should_receive(:charity=).with(charity)
      donation.should_receive(:campaign=).with(campaign)

      credit_card.should_receive(:first_name=).with(customer.first_name)
      credit_card.should_receive(:last_name=).with(customer.last_name)

      customer.should_receive(:purchase).with([donation], :from => charity).and_return(order)
      donation.should_receive(:order=).with(order)

      subject.charity = charity
      subject.campaign = campaign
      subject.donation = donation
      subject.customer = customer
      subject.credit_card = credit_card
      subject.request_remote_ip = ip
    end

    describe 'DonationOrder is valid' do
      before do
        order.should_receive(:pay).with(credit_card, :ip => ip).and_return(payment)
        subject.stub(:valid?).and_return(true)
      end

      describe 'payment is valid' do
        before do
          subject.should_receive(:valid_payment?).and_return(true)
        end

        it 'returns true' do
          subject.save.should eq(true)
        end
      end

      describe 'payment is not valid' do
        before do
          subject.should_receive(:valid_payment?).and_return(false)
        end

        it 'returns false' do
          subject.save.should eq(false)
        end
      end
    end

    describe 'when DonationOrder is invalid' do
      before do
        subject.stub(:invalid?).and_return(false)
      end

      it "returns false" do
        subject.save.should eq(false)
      end
    end
  end

  describe "#valid_payment?" do
    before do 
      subject.instance_variable_set("@payment", payment)
    end

    describe 'when payment is successful' do
      it 'adds the errors to the record' do
        payment.should_receive(:success?).and_return(true)
        subject.send(:valid_payment?).should eq(true)
        subject.errors[:payment].should be_empty
      end
    end

    describe 'when payment is not successful' do
      it 'does not add any errors' do
        payment.should_receive(:success?).and_return(false)
        payment.should_receive(:message).and_return("Bogus, like, credit card man")
        subject.send(:valid_payment?).should eq(false)
        subject.errors[:payment].should eq(["Bogus, like, credit card man"])
      end
    end
  end
  
  describe "#order" do
    it 'is readable' do
      lambda { subject.order }.should_not raise_error(NoMethodError)
    end
  end

  describe "#payment" do
    it 'is readable' do
      lambda { subject.payment }.should_not raise_error(NoMethodError)
    end
  end

  describe "#donation=" do
    it 'assigns a donation' do 
      subject.donation = donation
      subject.donation.should eq(donation)
    end
    it 'builds a Donation with hash' do
      subject # force init
      Donation.should_receive(:new).with(params)
      subject.donation = params
    end
  end

  describe "#charity=" do
    it 'assigns a charity' do
      subject.charity = charity
      subject.charity.should eq(charity)
    end
  end

  describe "#campaign=" do
    it 'assigns a campaign' do
      subject.campaign = campaign
      subject.campaign.should eq(campaign)
    end
  end

  describe "#customer=" do
    it 'assigns a customer' do 
      subject.customer = customer
      subject.customer.should eq(customer)
    end
    it 'builds a Customer with hash' do 
      subject # force init
      Customer.should_receive(:new).with(params)
      subject.customer = params
    end
  end

  describe "#credit_card=" do
    it 'assigns an credit_card' do 
      subject.credit_card = credit_card
      subject.credit_card.should eq(credit_card)
    end
    it 'builds a ActiveMerchant::Billing::CreditCard with hash' do 
      subject # force init
      ActiveMerchant::Billing::CreditCard.should_receive(:new).with(params)
      subject.credit_card = params
    end
  end
end
