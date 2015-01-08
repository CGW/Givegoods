require 'spec_helper'

describe 'layouts/bootstrap/campaigns' do

  it "renders the bootstrap layout" do 
    render
    view.should render_template('layouts/bootstrap')
  end

  it "has a link to the campaigns javascript in content_for :javascripts" do
    render
    view.content_for(:javascripts).should have_xpath("//script[@src='#{view.asset_path('bootstrap/campaigns.js')}']")
  end

  it "has a link to the campaigns stylesheet in content_for :stylesheets" do
    render
    view.content_for(:stylesheets).should have_xpath("//link[@href='#{view.asset_path('bootstrap/campaigns.css')}']")
  end
end
