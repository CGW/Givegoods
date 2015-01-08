require 'spec_helper'

describe DonationOrdersController do

  describe "POST :create" do
    let(:charity)       { mock_model(Charity) }
    let(:campaign)      { mock_model(Campaign, name: 'Donate to AFS') }
    let(:campaign_stat) { mock('CampaignStat') }
    let(:params)        { {"things" => "stuff"} }

    before do
      campaign_for_charity_scope = double('CharityScope')

      # find_charity
      charity_scope = double('CharityScope')
      Charity.should_receive(:active).and_return(charity_scope)
      charity_scope.should_receive(:find).with(charity.id.to_s).and_return(charity)
      
      # find_campaign
      Campaign.should_receive(:for_charity).and_return(campaign_for_charity_scope)
      campaign_for_charity_scope.should_receive(:"find_by_slug!").with(campaign.id.to_s).and_return(campaign)
      CampaignStat.should_receive(:for).with(campaign).and_return(campaign_stat)

      DonationOrder.should_receive(:new).with(params).and_return(donation_order)
      donation_order.should_receive(:charity=).with(charity)
      donation_order.should_receive(:campaign=).with(campaign)
      donation_order.should_receive(:request_remote_ip=)
    end

    describe "successfully" do
      let(:donation_order) { mock_model(DonationOrder).as_new_record }
      let(:order) { mock_model(MerchantSidekick::PurchaseOrder) }

      before do
        donation_order.stub(:save).and_return(true)
        donation_order.stub(:order).and_return(order)

        OrderMailer.should_receive(:paid).with(order).and_return(double('Mailer', :deliver => true))
        
        post :create, :charity_id => charity.id, :campaign_id => campaign.id, :donation_order => params
      end

      it "requires SSL"
      it { redirect_to(order_path(order)) }
      it { should_not render_template('donation_orders/new') }
      it { should_not render_template('layouts/bootstrap/campaigns') }
    end

    describe "with errors" do
      let(:params) { {"errors" => "all over the place"} }
      let(:donation_order) { mock_model(DonationOrder).as_new_record }

      before do
        donation_order.should_receive(:save).and_return(false)
        post :create, :charity_id => charity.id, :campaign_id => campaign.id, :donation_order => params
      end

      it "requires SSL"
      it { should respond_with(:success) }
      it { should assign_to(:charity).with(charity) }
      it { should assign_to(:campaign).with(campaign) }
      it { should assign_to(:campaign_stat).with(campaign_stat) }
      it { should assign_to(:donation_order).with(donation_order) }
      it { should render_template('layouts/bootstrap/campaigns') }
      it { should render_template('donation_orders/new') }
    end
  end
end
