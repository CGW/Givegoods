require 'spec_helper'

describe "charities/index" do
  let(:charities) { create_list(:charity, 4) }

  before do
    assign(:charities, charities)
  end

  describe "a merchant is set" do
    let(:merchant)   { create(:merchant) }

    before do 
      assign(:merchant, merchant)
      render
    end

    it "has a grid-header-help" do
      rendered.should have_selector('h1', :text => "#{merchant.name} directly supports all the charities shown below")
    end

    it "renders the merchants/_grid_info partial" do
      view.should render_template(:partial => 'merchants/_grid_info')
    end
  end

  describe "no merchant is set" do
    before do
      render
    end

    it "has a title" do
      rendered.should have_selector('h1', :text => 'Charities')
    end

    it "renders charities/_grid_controls partial" do
      view.should render_template(:partial => 'charities/_grid_controls', :count => 1)
    end

    it "renders charities/_index partial" do
      view.should render_template(:partial => 'charities/_index', :count => 1)
    end
  end
end
