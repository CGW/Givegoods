require 'spec_helper'

describe "shared/grid/_bundle" do
  let(:charity) { create(:charity) }
  let(:bundle)  { create(:bundle_with_bundlings) }
  let(:donation_value) { bundle.donation_value.format(:no_cents_if_whole => true) }
  let(:total_offer_value) { bundle.total_offer_value.format(:no_cents_if_whole => true) }

  before do
  end

  it "has a grid card and cart anchor bundle" do
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should have_selector("div##{dom_id(bundle)}")

    merchant_ids = bundle.offers.map(&:merchant_id)
    rendered.should have_xpath(".//a[@href='#{charity_bundle_path(charity, bundle)}']")
    rendered.should have_xpath(".//a[@data-merchants='#{merchant_ids.join(',')}']")
  end

  it "has the bundle grid image" do
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should have_image(bundle.image.grid)
  end

  it "has a title" do
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should have_content("Donate #{donation_value}: #{bundle.name}")
  end

  it "has a tagline" do
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should have_content("How it helps: #{bundle.tagline}")
  end

  it "has the notes" do
    bundle.notes = "Holy diver, you've been lost so long in the midnight sea. Oh you won't please rescue me!"
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should have_content(bundle.notes)
  end

  it "does not show tagline text if none exists" do
    bundle.tagline = "";
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should_not have_content("How it helps: #{bundle.tagline}")
  end

  it "has a list of items in the bundle" do
    render :partial => 'bundles/bundle', :collection => [bundle], :locals => { :charity => charity }
    rendered.should have_content("As a thank you, save up to #{total_offer_value} in rewards at:")
    bundle.bundlings.map(&:offer).each do |offer|
      rendered.should have_selector('li', :text => offer.merchant.name)
    end
  end
end
