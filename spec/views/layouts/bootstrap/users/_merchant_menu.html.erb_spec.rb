require 'spec_helper'

describe 'layouts/bootstrap/users/_merchant_menu' do
  let(:user)     { mock_model(User) }
  let(:merchant)  { mock_model(Merchant) }
  let(:campaign) { mock_model(Campaign) }

  before do
    view.stub(:current_user).and_return(user)
  end

  describe "when user has no merchant" do
    before do
      user.stub(:merchant).and_return(nil)
      render
    end

    it "has 'no picture' image" do
      rendered.should have_image(Merchant.new.picture.grid.url)
    end

    it "shows the merchant profile link" do
      rendered.should have_link('Merchant profile', :url => edit_user_merchant_path)
    end

    it "does not show the reward settings link" do
      rendered.should_not have_link('Reward settings')
    end

    it "does not show the purchase history link" do
      rendered.should_not have_link('Purchase history')
    end

    it "shows the account settings link" do
      rendered.should have_link('Account settings', :url => edit_user_registration_path)
    end
  end

  describe "when user has a merchant" do
    before do
      user.stub(:merchant).and_return(merchant)
      merchant.stub(:campaign).and_return(campaign)
      merchant.stub_chain(:picture, :grid, :url).and_return('/image')

      render
    end

    it "has merchant image" do
      rendered.should have_image('/image')
    end

    it "does not show the reward settings link" do
      rendered.should have_link('Reward settings', :url => edit_user_merchant_offer_path)
    end
  end
end
