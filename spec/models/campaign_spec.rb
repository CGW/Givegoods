require 'spec_helper'

describe Campaign do
  include CampaignExampleHelpers

  [:slug, :tagline, :tiers_attributes, :charity_id].each do |attr|
    #it { should allow_mass_assignment_of(attr).as(:admin) }
    it { should allow_mass_assignment_of(attr) }
  end

  it { should belong_to(:charity) }
  it { should validate_presence_of(:charity).with_message(/can't be blank/) }

  it { should have_many(:tiers).dependent(:destroy) }
  it { should have_many(:donations) }

  [:slug, :tagline].each do |attr|
    it { should validate_presence_of(attr).with_message(/can't be blank/) }
    it { should ensure_length_of(attr).is_at_most(255).with_long_message(/is too long/) }
  end

  it { should validate_format_of(:slug).with('test-hello-1') }
  it { should validate_format_of(:slug).not_with('&*^').with_message(/is invalid/) }

  it { should accept_nested_attributes_for(:tiers).and_accept({:amount => '20.00', :tagline => 'help us'}).but_reject({:amount => '', :placeholder => ''}) }

  describe "uniqueness validators" do
    before do
      # We need a campaign record for validates uniqueness tests  
      create_campaign_with_tier_taglines
    end

    it { should validate_uniqueness_of(:slug).scoped_to(:charity_id) }
  end

  describe "#for_charity" do 
    it "limits campaigns returned to the specified charity" do
      charity = mock_model(Charity)
      subject.class.for_charity(charity).should eq(subject.class.where(:charity_id => charity.id))
    end
  end

  describe "#with_tiers" do
    it "includes the campaigns tiers" do
      subject.class.with_tiers.should eq(subject.class.includes(:tiers))
    end
  end
 
  describe "#name" do
    it "returns the campaign name" do
      charity = create(:charity)
      subject.charity = charity

      subject.name.should eq("Donate to #{charity.name}")
    end
  end
end
