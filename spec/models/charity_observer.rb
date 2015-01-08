require 'spec_helper'

describe CharityObserver do
  let(:charity)  { stub(:charity, :name => "Alameda Red Cross") }
  let(:observer) { CharityObserver.instance }

  describe "#after_create" do
    it "creates a campaign and notifies admins" do
      observer.should_receive(:create_campaign).and_return(true)
      observer.after_create(charity)
    end
  end

  describe "#create_campaign" do
    it "creates a campaign for the charity" do
      charity.stub_chain(:campaign, :present?).and_return(false)
      charity.should_receive(:create_campaign).with({
        :tagline          => "Make a contribution to #{charity.name}",
        :slug             => "donate",
        :tiers_attributes => [
          { :amount => 25 },
          { :amount => 50 },
          { :amount => 100 },
          { :amount => 250 },
        ]
      })

      observer.send(:create_campaign, charity)
    end

    it "does not create a campaign for the charity if one exists" do
      charity.stub_chain(:campaign, :present?).and_return(true)
      charity.should_not_receive(:create_campaign)

      observer.send(:create_campaign, charity)
    end
  end
end
