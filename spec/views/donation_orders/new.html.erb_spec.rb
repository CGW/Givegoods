require 'spec_helper'

describe 'donation_orders/new' do
  include CampaignExampleHelpers

  let(:campaign)       { create_campaign_with_tier_taglines }
  let(:charity)        { campaign.charity }
  let(:donation_order) { DonationOrder.new }
  let(:campaign_stat)  { mock('CampaignStat') }

  before do
    assign(:campaign, campaign)
    assign(:charity, charity)
    assign(:donation_order, donation_order)
    assign(:campaign_stat, campaign_stat)
  end

  it "renders the donation order form" do
    render
    view.should render_template(:partial => 'donation_orders/_form_fields_info', :count => 1)
  end

  describe "error messaging" do
    let(:error) { "An error on" }

    [
      "payment",
      "donation.amount",
      "customer.first_name",
      "customer.email",
      "customer.billing_address.street",
      "customer.billing_address.city",
      "customer.billing_address.province_code",
      "customer.billing_address.postal_code",
      "customer.terms"
    ].each do |field|
      it "shows the error for #{field}" do
        donation_order.errors.add field, "#{error} #{field}"
        render

        rendered.should have_content('Oops! Looks like there was a problem with some of the information you gave us')
        rendered.should have_selector('ul li', :text => "#{error} #{field}")
      end
    end
  end

  describe "donation order form" do
    before do
      render
    end

    it "has a form for a new donation order" do
      rendered.should have_selector("form", :method => "post",
                                    :action => charity_campaign_donation_orders_path(charity, campaign))
    end

    it "has has a title for the charity receiving the donation" do
      rendered.should have_selector('h4', :text => "Donate to #{charity.name}")
    end

    it "renders the donation order form amount partial" do
      view.should render_template(:partial => 'donation_orders/_form_fields_amount', :count => 1)
    end

    it "has terms field" do
      rendered.should have_unchecked_field('I agree to the Terms and Conditions')
    end

    it "has the donate now button" do
      rendered.should have_button('Donate Now')
    end
  end
end
