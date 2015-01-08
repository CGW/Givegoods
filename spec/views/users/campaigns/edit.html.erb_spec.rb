require 'spec_helper'

describe 'users/campaigns/edit' do
  let(:charity)  { create(:charity) }
  let(:campaign) { charity.campaign }

  before do
    assign(:charity, charity)
    assign(:campaign, campaign)
  end

  describe "when the charity active" do
    before do
      charity.stub(:active?).and_return(true)
      render
    end

    it "has title" do
      rendered.should have_selector('h1', :text => 'Donation page')
    end

    it "renders the charity form" do
      view.should render_template(:partial => 'users/campaigns/_form')
    end
  end

  describe "when the charity is inactive" do
    before do
      charity.stub(:active?).and_return(false)
      render
    end

    it "does not show link to the donate page" do
      rendered.should_not have_link(charity_campaign_default_url(charity, campaign.slug), :url => charity_campaign_default_path(charity, campaign.slug))
    end
  end
end
