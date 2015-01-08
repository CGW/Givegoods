require 'spec_helper'

describe 'layouts/bootstrap/users/_charity_menu' do
  let(:user)     { mock_model(User) }
  let(:charity)  { mock_model(Charity) }
  let(:campaign) { mock_model(Campaign) }

  before do
    view.stub(:current_user).and_return(user)
  end

  describe "when user has no charity" do
    before do
      user.stub(:charity).and_return(nil)
      render
    end

    it "has 'no picture' image" do
      rendered.should have_image(Charity.new.picture.grid.url)
    end

    it "shows the charity profile link" do
      rendered.should have_link('Charity profile', :url => edit_user_charity_path)
    end

    it "does not show the campaign link" do
      rendered.should_not have_link('Donation page')
    end

    it "shows the account settings link" do
      rendered.should have_link('Account settings', :url => edit_user_registration_path)
    end
  end

  describe "when user has a charity" do
    let(:user_policy) { double('Policy') }

    before do
      view.stub(:user_policy).and_return(user_policy)

      user.stub(:charity).and_return(charity)
      charity.stub(:campaign).and_return(campaign)
      charity.stub_chain(:picture, :grid, :url).and_return('/image')
      charity.stub(:active?).and_return(false)
      user_policy.stub(:active?).and_return(false)

      render
    end

    it "has charity image" do
      rendered.should have_image('/image')
    end

    it "does not show the donation page link" do
      rendered.should_not have_link('Donation page', :url => edit_user_campaign_path)
    end

    describe "that is active" do
      before do
        charity.stub(:active?).and_return(true)
        render
      end

      it "shows the donation page link" do
        rendered.should have_link('Donation page', :url => edit_user_campaign_path)
      end
    end

    describe "that has an active user_policy" do
      before do
        user_policy.stub(:active?).and_return(true)
        render
      end

      it "shows the donation page link" do
        rendered.should have_link('Donation page', :url => edit_user_campaign_path)
      end
    end

  end
end
