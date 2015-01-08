require 'spec_helper'

describe "charities/landing" do
  let(:campaign) { mock_model(Campaign, :slug => 'donate') }
  let(:charity) { mock_model(Charity, :name => 'Alameda Red Cross', :campaign => campaign) }

  before do
    assign(:charity, charity)
    render
  end

  it "has a title" do
    rendered.should have_selector('h1', :text => "Donate to #{charity.name}")
  end

  it "has a link to the charity's rewards page" do
    button_text = "Donate With Rewards"
    rendered.should have_selector('a.button', :text => button_text)
    rendered.should have_link(button_text, :href => charity_merchants_path(charity))
  end

  it "has a linking to the charity's default campaign" do
    button_text = "Donate Without Rewards"
    rendered.should have_selector('a.button', :text => button_text)
    rendered.should have_link(button_text, :href => charity_campaign_default_path(charity, charity.campaign.slug))
  end
end
