require 'spec_helper'

describe "merchants/_index" do
  let(:merchants) { create_list(:offer, 4).map(&:merchant) }

  describe "when merchants exist" do
    before do
      render :partial => 'merchants/index', :locals => { :merchants => merchants }
    end

    it "has has surrounding div with correct classes" do
      rendered.should have_selector('div.card-group.card-group-singles')
    end

    it "has a grid card for each merchant" do
      view.should render_template('merchants/_merchant', :count => 4)
    end
  end

  describe "when no merchants exist" do
    it "has a message when no merchants exist" do
      render :partial => 'merchants/index', :locals => { :merchants => [] }
      rendered.should have_content("Sorry! We couldn't find any merchants that matched your request.")
    end
  end

  describe "when a charity is set and has bundles" do
    let(:charity) { create(:charity) }
    let!(:bundles) { create_list(:bundle_with_bundlings, 3, :charity => charity) }

    def render_partial_with_bundles
      render :partial => 'merchants/index', :locals => { :merchants => merchants, :charity => charity, :bundles => bundles }
    end

    it "has a card category for the bundles" do
      render_partial_with_bundles
      rendered.should have_selector('.card-category', :text => 'Limited Time Only: Exclusive Reward Packages')
    end

    it "has a card category for individual rewards" do
      render_partial_with_bundles
      rendered.should have_selector('.card-category', :text => 'Choose Individual Rewards')
    end

    describe "when the charity has a custom campaign bundle tagline" do
      it "has a card category with the text" do
        charity.campaign_bundle_tagline = 'Sick shit son'
        render_partial_with_bundles
        rendered.should have_selector('.card-category', :text => 'Sick shit son')
      end
    end

    it "renders a partial for each bundle" do
      render_partial_with_bundles
      view.should render_template('bundles/_bundle', :count => 3)
    end
  end

  it "renders grid/index partial" do
    render :partial => 'merchants/index', :locals => { :merchants => merchants }
    view.should render_template('shared/grid/_index')
  end
end


