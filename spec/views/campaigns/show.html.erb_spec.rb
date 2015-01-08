require 'spec_helper'

describe 'campaigns/show' do
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

    campaign_stat.stub(:donations_count).and_return(0)
    campaign_stat.stub(:donations_amount_sum).and_return(Money.new(0))
  end

  describe "donation order form" do
    before do
      donation_order.donation.amount = 15
      render
    end

    it "has a form for a new donation order" do
      rendered.should have_selector("form", :method => "post",
                                    :action => charity_campaign_donation_orders_path(charity, campaign))
    end

    it "renders the donation order form amount partial" do
      view.should render_template(:partial => 'donation_orders/_form_fields_amount', :count => 1)
    end

    it "renders the donation order form info partial" do
      view.should render_template(:partial => 'donation_orders/_form_fields_info', :count => 1)
    end

    it "has terms field" do
      rendered.should have_unchecked_field('I agree to the Terms and Conditions')
    end

    it "has the donate now button" do
      rendered.should have_button('Donate Now')
    end
  end

  describe ".campaign-banner" do
    it "has the campaign charity's name" do
      render
      rendered.should have_selector('.campaign-banner h5', :text => "Donate to #{charity.name}")
    end

    it "has a button to the charity's rewards page" do
      render
      rendered.should have_selector('.campaign-banner a.btn.btn-primary', :text => 'Get Rewards When You Donate')
    end
  end

  describe ".campaign-header" do
    it "has the campaign's tagline" do
      render
      rendered.should have_selector('h1', :text => campaign.tagline)
    end
  end

  describe '.campaign-content' do
    before do
      render
    end

    it "has a button and tagline for each tier" do
      campaign.tiers.each do |tier|
        rendered.should have_selector('button.btn-tier', :text => tier.amount.format(:no_cents_if_whole => true))
        rendered.should have_selector('.campaign-tier-description', :text => tier.tagline)
      end
    end

    it "has form for other amount" do
      rendered.should have_field('other_amount', :with => '')
      rendered.should have_selector('.form-amount button', :text => 'Submit')
    end
  end

  describe '.campaign-side' do
    it "has the campaign charity's image" do
      render 
      rendered.should have_image(charity.picture.campaign_sidebar)
    end

    it "has .donation-stats element when there are 5 or more donations" do
      campaign_stat.stub(:donations_count).and_return(5)
      render 

      rendered.should have_selector(".campaign-side .donation-stats")
    end

    it "renders the donation stats with delimiters" do
      campaign_stat.stub(:donations_count).and_return(999999)
      campaign_stat.stub(:donations_amount_sum).and_return(Money.new(99999900))
      render 

      rendered.should have_selector(".donation-stats", :text => /Raised:\s*\$999,999/)
      rendered.should have_selector(".donation-stats", :text => /Donors:\s*\999,999/)
    end

    it "does not render donation stats" do
      render
      rendered.should_not have_selector(".campaign-side", :text => /Raised:\s*\$0/)
      rendered.should_not have_selector(".campaign-side", :text => /Donors:\s*\0/)
    end

    it "has the an about us for the charity" do
      render
      rendered.should have_selector(".campaign-side", :text => /About Us:\s*#{charity.description}/)
    end

    it "does not have an about us if charity description is not present" do
      charity.description = nil
      assign(:charity, charity)
      render

      rendered.should_not have_selector(".campaign-side", :text => "About Us:")
    end

    it "has the charity's website" do
      render 
      rendered.should have_selector(".campaign-side", :text => "Visit our website.")
      rendered.should have_link('website', :href => charity.website_url)
    end

    it "does not have the charity's website" do
      charity.website_url = nil
      assign(:charity, charity)
      render

      rendered.should_not have_selector(".campaign-side", :text => "Visit our website")
    end
  end

end
