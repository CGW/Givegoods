require 'spec_helper'

describe Charity do
  it { should belong_to(:user) }
  it { should have_one(:campaign) }

  [:name, :ein, :website_url].each do |attr|
    it { should validate_presence_of(attr).with_message(/can't be blank/) }
  end
  
  # Email is valid if matching a simple pattern:
  #   <any character>@<alphanum|->.<a-z repeated 2 or more times>
  it { should allow_value("charles+test@chuckg.org").for(:email) }
  it { should allow_value("charles12@chuckg.org").for(:email) }
  it { should_not allow_value("@nah.12o").for(:email) }

  describe "when active" do
    before do
      subject.status = 'active'
    end

    [:email, :description].each do |attr|
      it { should validate_presence_of(attr).with_message(/can't be blank/) }
    end
  end

  describe "unique fields" do
    before do
      create(:charity)
    end
    it { should validate_uniqueness_of(:ein).with_message("A charity with that EIN already exists") }
  end

  [:name, :ein, :email, :description, :website_url].each do |attr|
    it { should normalize_attribute(attr) }
    it { should normalize_attribute(attr).from('    ').to(nil) }
  end
  
  it { should normalize_attribute(:website_url).from('givegoods.org').to('http://givegoods.org') }
  it { should normalize_attribute(:website_url).from('https://givegoods .org ').to('https://givegoods%20.org') }

  describe "#activate!" do
    subject { build(:inactive_charity) }

    before do
      subject.should_receive(:enter_active)
    end

    it "calls enter_active" do
      subject.activate
    end
  end

  describe "#enter_active" do
    before do
      EmailService.should_receive(:activated_charity).and_return(true)
    end

    it "sends emails" do
      subject.send(:enter_active).should eq(true)
    end
  end
end
