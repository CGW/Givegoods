require 'spec_helper'

describe 'charities/_grid_info' do
  let(:charity) { create(:active_charity) }

  it "has the charity info" do
    render :partial => 'charities/grid_info', :locals => { :charity => charity } 

    rendered.should have_image(charity.picture.grid_info)
    rendered.should have_selector('#grid-info', :text => charity.name)
    rendered.should have_content(charity.description)
    rendered.should have_xpath(".//a[@href='#{charity.website_url}' and @data-popup='true']", :text => "website")
  end

  describe 'when the charity has a campaign' do
    it 'displays a button linking to the campaign' do
      render :partial => 'charities/grid_info', :locals => { :charity => charity } 
      rendered.should have_link("I want to skip rewards & donate now", :href => charity_campaign_default_path(charity, charity.campaign.slug))
    end
  end

  it "does not have the description if none exists" do
    description = charity.description
    charity.description = nil

    render :partial => 'charities/grid_info', :locals => { :charity => charity } 
    rendered.should_not have_content(description)
  end

  it "does not have a link to the website if none exists" do
    charity.website_url = nil
    render :partial => 'charities/grid_info', :locals => { :charity => charity } 
    rendered.should_not have_link('website')
  end
end
