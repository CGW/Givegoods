require 'spec_helper'

describe Users::CampaignsController do
  let(:charity)  { mock_model(Charity) }
  let(:campaign) { mock_model(Campaign) }
  let(:user)     { create(:user) }

  describe "for anonymous users" do
    it "GET :edit redirects" do
      get :edit
      response.should redirect_to(user_session_path)
    end
  end

  describe "for a user with a charity" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:charity).and_return(charity)
      charity.stub(:campaign).and_return(campaign)

      sign_in(user)
    end

    describe "GET :edit" do
      before do
        get :edit
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/campaigns/edit') }
      it { should assign_to(:charity).with(charity) }
      it { should assign_to(:campaign).with(campaign) }
    end

    describe "PUT :update" do
      let(:params) { { 'good' => 'day' } }

      describe "with valid params" do
        before do
          campaign.should_receive(:update_attributes).with(params).and_return(true)
          put :update, :campaign => params
        end

        it { should set_the_flash.to("Your donation page has been updated.") }
        it { should redirect_to(edit_user_campaign_path) }
      end

      describe "with invalid params" do
        before do
          campaign.should_receive(:update_attributes).with(params).and_return(false)
          put :update, :campaign => params
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/campaigns/edit') }
        it { should assign_to(:charity).with(charity) }
        it { should assign_to(:campaign).with(campaign) }
      end
    end
  end

  describe "for a user with no charity" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:charity).and_return(nil)

      sign_in(user)
    end

    describe "GET :edit" do
      before do
        get :edit
      end

      it { should redirect_to(new_user_charity_path) }
    end

    describe "GET :update" do
      before do
        put :update
      end

      it { should redirect_to(new_user_charity_path) }
    end
  end
end
