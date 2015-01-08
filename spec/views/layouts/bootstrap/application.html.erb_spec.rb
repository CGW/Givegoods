require 'spec_helper'

describe 'layouts/bootstrap/application' do

  before do
    controller.stub(:user_signed_in?).and_return(false)
  end

  it "renders the bootstrap layout" do 
    render
    view.should render_template('layouts/bootstrap')
  end

  it "has a link to the application javascript in content_for :javascripts" do
    render
    view.content_for(:javascripts).should have_xpath("//script[@src='#{view.asset_path('bootstrap/application.js')}']")
  end

  it "has a link to the application stylesheet in content_for :stylesheets" do
    render
    view.content_for(:stylesheets).should have_xpath("//link[@href='#{view.asset_path('bootstrap/application.css')}']")
  end

  describe "content_for :body" do
    describe "alert" do
      [:warning, :error, :notice, :alert].each do |alert|
        it "shows #{alert} messages" do
          flash[alert] = "Hello!"
          render
          rendered.should have_selector("div.alert.alert-#{alert}", :text => "Hello!")
        end

        it "does not show #{alert} messages if none present" do
          render
          rendered.should_not have_selector("div.alert")
        end
      end
    end

    describe "content_for :content" do
      before do
        view.content_for(:content) do
          'Hello nerd'
        end
        render
      end

      it "is rendered when present" do
        rendered.should have_selector('.content', :text => 'Hello nerd')
      end
    end

    it "renders the header partial" do
      render
      view.should render_template(:partial => 'layouts/_header')
    end

    it "renders the footer partial" do
      render
      view.should render_template(:partial => 'layouts/_footer')
    end
  end
end
