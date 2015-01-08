require 'spec_helper'

describe "merchants/index" do
  let(:merchants) { create_list(:offer, 4).map(&:merchant) }

  before do
    assign(:merchants, merchants)
  end

  describe "a charity is set" do
    let(:charity) { create(:charity) }
    let(:bundles) { [] } 

    before do 
      assign(:charity, charity)
      assign(:bundles, bundles)
      render
    end

    it "has a grid-header-help" do
      rendered.should have_selector('h1', :text => "The rewards below directly support #{charity.name}")
    end

    it "renders the charities/_grid_info partial" do
      view.should render_template(:partial => 'charities/_grid_info')
    end
  end

  describe "no charity is set" do
    before do 
      render
    end

    it "has a title" do
      rendered.should have_selector('h1', :text => 'Rewards')
    end

    it "renders merchants/_grid_controls partial" do
      view.should render_template(:partial => 'merchants/_grid_controls')
    end
  end

  it "renders merchants/_index partial" do
    render
    view.should render_template(:partial => 'merchants/_index')
  end
end
