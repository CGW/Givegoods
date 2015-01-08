require 'spec_helper'

describe 'donation_orders/_form_fields_amount' do
  include CampaignExampleHelpers

  let!(:campaign)       { create_campaign_with_tier_taglines }
  let!(:charity)        { campaign.charity }
  let!(:donation_order) { DonationOrder.new }
  let(:form)  { ActionView::Helpers::FormBuilder.new(:donation_order, donation_order, view, {}, nil) }

  before do
    render :partial => 'donation_orders/form_fields_amount', :locals => { :form => form, :charity => charity, :campaign => campaign, :donation_order => donation_order }
  end

  it "has a donation amount field" do
    rendered.should have_field('donation_order[donation][amount]', :type => :input)
  end

  it "has anonymous field" do
    rendered.should have_unchecked_field('Contribute anonymously')
    rendered.should have_selector_with('a', 
                                       :rel => 'tooltip', 
                                       :title => "An anonymous donation means the charity knows your donation amount but does not receive your name or any other contact information about you.", 
                                       :text => "[?]")
  end
end
