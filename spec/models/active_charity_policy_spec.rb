require 'spec_helper'

describe ActiveCharityPolicy do
  let(:address) { double('address') }
  let(:picture) { double('picture') }
  let(:charity) { mock_model('Charity', :picture => picture, :address => address) }
  subject { ActiveCharityPolicy.new(charity) }

  before do
    picture.stub(:url).and_return("/pic.jpg")
    picture.stub(:default_url).and_return("/pic.jpg")
  end

  describe "validates basic_information" do
    it "has an error if charity is not valid" do
      charity.stub(:valid?).and_return(false)
      subject.valid?
      subject.errors[:basic_information].should eq(['Create a basic account.'])
    end
    it "does not have not have an error" do
      subject.valid?
      subject.errors[:basic_information].should eq([])
    end
  end 

  describe "validates picture" do
    it "has an error if charity.picture has not been changed" do
      subject.valid?
      subject.errors[:picture].should eq(['Add a picture to display on charity page.'])
    end
    it "does not have an error if charity.picture is present" do
      picture.stub(:url).and_return("/new_pic.jpg")
      subject.valid?
      subject.errors[:picture].should eq([])
    end
  end

  describe "validates description" do
    it "has an error if charity does not have a description" do
      subject.valid?
      subject.errors[:description].should eq(['Write a short description for your charity.'])
    end
    it "does not have not have an error" do
      charity.stub(:description).and_return("Stuff about a charity.")
      subject.valid?
      subject.errors[:description].should eq([])
    end
  end 

  describe "validates contact information" do
    it "has an error if charity email is blank or the address is not complete" do 
      subject.valid?  
      subject.errors[:contact_information].should eq(['Enter your contact information.'])
    end
    it "does not have not have an error" do
      address_policy = double('CompleteAddressPolicy')
      charity.stub(:email).and_return('contact@charity.org') 
      CompleteAddressPolicy.should_receive(:new).with(address).and_return(address_policy)
      address_policy.should_receive(:complete?).and_return(true)

      subject.valid?
      subject.errors[:contact_information].should eq([])
    end
  end

  describe "#active?" do
    it "returns result of valid?" do
      subject.should_receive(:valid?).and_return(true)
      subject.active?.should be_true
    end
  end

  describe "#messages_for" do
    {
      :basic_information   => 'Create a basic account.',
      :picture             => 'Add a picture to display on charity page.',
      :description         => 'Write a short description for your charity.',
      :contact_information => 'Enter your contact information.'
    }.each do |attr, message| 
      it "returns a message for #{attr}" do
        subject.message_for(attr).should eq(message)
      end
    end
  end
end
