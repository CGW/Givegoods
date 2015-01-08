require 'spec_helper'

describe CampaignsController do

  describe 'GET :show' do
    let(:charity)        { mock_model(Charity, slug: 'alameda-family-services') }
    let(:campaign)       { mock_model(Campaign, slug: 'donate', name: 'Donate to AFS') }
    let(:donation_order) { mock_model(DonationOrder) }
    let(:campaign_stat)  { mock(CampaignStat) }

    before do 
      # load_charity
      charity_scope = double('CharityScope')
      Charity.should_receive(:active).and_return(charity_scope)
      charity_scope.should_receive(:find).with(charity.slug).and_return(charity)

      DonationOrder.should_receive(:new).and_return(donation_order)
      Campaign.stub_chain(:for_charity, :with_tiers, "find_by_slug!").and_return(campaign)
      CampaignStat.should_receive(:for).with(campaign).and_return(campaign_stat)

      get :show, id: campaign.slug, charity_id: charity.slug
    end

    it "requires SSL"
    it { should respond_with(:success) }
    it { should render_template('layouts/bootstrap/campaigns') }
    it { should render_template('campaigns/show') }
    it { should assign_to(:title).with(campaign.name) }
    it { should assign_to(:charity).with(charity) }
    it { should assign_to(:campaign).with(campaign) }
    it { should assign_to(:campaign_stat).with(campaign_stat) }
    it { should assign_to(:donation_order).with(donation_order) }
  end

end
