require 'spec_helper'

describe 'layouts/application' do
  before do 
    view.stub(:user_signed_in?).and_return(false)
  end

  describe "<head>" do
    before do
      render
    end

    it "has a title" do
      rendered.should have_selector('title', :text => view.page_title)
    end

    it "renders google analytics partial" do
      view.should render_template(:partial => 'layouts/_google_analytics', :count => 1)
    end

    it "renders get satisfaction partial" do
      view.should render_template(:partial => 'layouts/_get_satisfaction', :count => 1)
    end

    it "has a link to the application stylesheet" do
      rendered.should have_xpath("//link[@href='#{view.asset_path('application.css')}']")
    end

    it "has a link to the application javascript" do
      rendered.should have_xpath("//script[@src='#{view.asset_path('application.js')}']")
    end
  end

  describe "header" do
    it "does not render if @hide_header is set" do
      assign(:hide_header, true)
      render
      view.should_not render_template('layouts/_header')
    end

    it "renders by default" do
      render
      view.should render_template('layouts/_header')
    end
  end

  describe "footer" do
    it "renders the footer partial" do
      render
      view.should render_template(:partial => 'layouts/_footer')
    end
  end
end
