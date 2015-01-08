require 'spec_helper'

describe "merchants/_merchant" do
  let(:merchant) { create(:offer).merchant }

    it "has a grid card for the merchant" do
      render :partial => 'merchants/merchant', :locals => { :merchant => merchant }
      rendered.should have_selector("div##{dom_id(merchant)}")

      rendered.should have_xpath(".//a[@href='#{merchant_charities_path(merchant)}']")
      rendered.should_not have_xpath(".//div/a[@data-remote='true']")

      rendered.should have_image(merchant.picture.grid)
      rendered.should have_content(merchant.name)
      rendered.should have_content("Donate #{merchant.offer.donation_value.format(:no_cents_if_whole => true)}, Save up to #{merchant.offer.offer_value.format(:no_cents_if_whole => true)}.")
    end

  describe "charity has been set" do
    let(:charity)  { create(:charity) }

    it "shows a remote link to the charity_merchant_path" do
      render :partial => 'merchants/merchant', :locals => { :merchant => merchant, :charity => charity }

      rendered.should_not have_xpath(".//a[@href='#{merchant_charities_path(merchant)}']")
      rendered.should have_xpath(".//a[@href='#{charity_merchant_path(charity, merchant)}' and @data-remote='true']")
    end
  end
end
