require 'spec_helper'

describe CampaignStat do
  let(:campaign) { mock_model(Campaign) }

  describe "#for" do
    it "returns a new CampaignStat for the specified campaign" do
      campaign_stat = mock('CampaignStat')

      CampaignStat.should_receive(:new).with(:campaign => campaign).and_return(campaign_stat)
      CampaignStat.for(campaign).should eq(campaign_stat)
    end

    it "nil if the first argument is not a valid Campaign" do
      CampaignStat.for(mock_model("Donation")).should be_nil
    end
  end

  describe "#initialize" do
    it "assigns valid attributes" do
      campaign_stat = CampaignStat.new(:campaign => campaign)
      campaign_stat.campaign.should eq(campaign)
    end
    it "does not assign invalid attributes" do
      lambda { CampaignStat.new(:bad_attr => 'is bad') }.should raise_error
    end
  end

  describe "#campaign" do
    before do
      subject.instance_variable_set(:@campaign, campaign)
    end

    it "returns the campaign" do
      subject.campaign.should eq(campaign)
    end
  end

  describe "#campaign=" do
    it "does not assign @campaign and returns nil if the argument is not a Campaign" do
      subject.instance_variable_set(:@campaign, nil)
      subject.campaign = Object.new
      subject.instance_variable_get(:@campaign).should be_nil
    end

    it "assigns @campaign if the first argument is a campaign" do
      subject.campaign = campaign
      subject.instance_variable_get(:@campaign).should eq(campaign)
    end
  end

  describe "#donations_count" do
    it "returns the number of the donations" do
      subject.stub_chain(:valid_donations, :count).and_return(5)
      subject.donations_count.should eq(5)
    end
  end

  describe "#donations_amount_cents_sum" do
    it "returns the summed amount_cents of donations" do
      scope = mock('DonationsScope')
      subject.stub_chain(:valid_donations).and_return(scope)
      scope.stub(:sum).with(:amount_cents).and_return(10000)

      subject.donations_amount_cents_sum.should eq(10000)
    end
  end

  describe "#donations_amount_sum" do
    it "returns the summed amount of donations" do
      subject.should_receive(:donations_amount_cents_sum).and_return(1000)
      subject.donations_amount_sum.should eq(Money.new(1000))
    end
  end

  describe "#valid_donations" do
    let(:valid_donations) { mock('DonationsScope') }

    before do
      subject.campaign = campaign
    end

    it "returns a donations scope" do
      scope = mock('SuccessfulDonationsScope')
      campaign.stub_chain(:donations, :successful).and_return(scope)
      scope.should_receive(:where).with("amount_cents >= 500").and_return(valid_donations)
    
      subject.send(:valid_donations).should eq(valid_donations)
    end
  end
end
