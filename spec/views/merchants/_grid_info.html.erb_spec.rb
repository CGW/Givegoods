require 'spec_helper'

describe 'merchants/_grid_info' do
  let(:merchant) { create(:merchant) }

  it "has the merchant info" do
    render :partial => 'merchants/grid_info', :locals => { :merchant => merchant } 

    rendered.should have_image(merchant.picture.grid_info)
    rendered.should have_selector('#grid-info', :text => merchant.name)
    rendered.should have_content(merchant.description)

    address = merchant.address

    rendered.should have_content(address.street)
    rendered.should have_content("#{address.city}, #{address.state_code}")
    rendered.should have_content(address.postal_code)
    rendered.should have_content(address.phone)
    rendered.should have_xpath(".//a[@href='#{merchant.website_url}' and @data-popup='true']", :text => "website")
  end

  it "does not have the description if none exists" do
    description = merchant.description
    merchant.description = nil
    render :partial => 'merchants/grid_info', :locals => { :merchant => merchant } 
    rendered.should_not have_content(description)
  end

  it "does not display the merchant address if none exists" do
    merchant.address.street = nil
    render :partial => 'merchants/grid_info', :locals => { :merchant => merchant } 

    rendered.should_not have_selector('adresss')
  end

  it "does display the merchant phone number if none exists" do
    phone = merchant.address.phone
    merchant.address.phone = nil
    render :partial => 'merchants/grid_info', :locals => { :merchant => merchant } 

    rendered.should_not have_content(phone)
  end

  it "does not have a link to the website if none exists" do
    merchant.website_url = nil

    render :partial => 'merchants/grid_info', :locals => { :merchant => merchant } 
    rendered.should_not have_link('website')
  end
end
