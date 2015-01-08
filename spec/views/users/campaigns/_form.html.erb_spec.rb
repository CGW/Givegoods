require 'spec_helper'

describe 'users/campaigns/_form' do
  let(:campaign) { create(:charity).campaign }

  before do
    # Set the tier tagline
    campaign.tiers.each do |tier|
      tier.update_attributes(:tagline => "Donate #{tier.amount}")
    end
    render :partial => 'users/campaigns/form', :locals => { :campaign => campaign }
  end
  
  it "has a form for the campaign" do
    rendered.should have_form(:action => user_campaign_path, :class => 'form-horizontal')

    rendered.should have_xpath("//input[@name='campaign[name]'][@disabled]")
    rendered.should have_field('Tagline')

    rendered.should have_button('Update')
    rendered.should have_link('Cancel', :url => edit_user_campaign_path)
  end

  it "has fields for each campaign tier" do
    campaign.tiers.each_with_index do |tier, index| 
      rendered.should have_selector('label', :text => "Tier ##{index+1}")
      rendered.should have_field("campaign[tiers_attributes][#{index}][amount]", :with => tier.amount.format(:symbol => false))
      rendered.should have_field("campaign[tiers_attributes][#{index}][tagline]", :with => "Donate #{tier.amount}")
      rendered.should have_field("campaign[tiers_attributes][#{index}][_destroy]")
    end
  end

  it "has fields for a new tier" do
    new_index = campaign.tiers.count

    rendered.should have_selector('label', :text => "Add new tier")
    rendered.should have_field("campaign[tiers_attributes][#{new_index}][amount]", :with => "0.00")
    rendered.should have_field("campaign[tiers_attributes][#{new_index}][tagline]")
  end
end
