require 'spec_helper'

describe Users::MerchantsController do
  let(:merchant) { mock_model(Merchant) }
  let(:user)    { create(:user) }
  let(:params)  { {'hi' => 'mate'} }

  describe "for anonymous users" do
    it "GET :new redirects" do
      get :new
      response.should redirect_to(user_session_path)
    end

    it "POST :create redirects" do
      post :create
      response.should redirect_to(user_session_path)
    end

    it "GET :edit redirects" do
      get :edit
      response.should redirect_to(user_session_path)
    end

    it "PUT :update redirects" do
      put :update
      response.should redirect_to(user_session_path)
    end
  end

  describe "for a user with a merchant" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:merchant).and_return(merchant)

      sign_in(user)
    end

    describe "GET :new" do
      before do
        get :new
      end

      it { should redirect_to(edit_user_merchant_path) }
    end

    describe "POST :create" do
      before do
        post :create
      end

      it { should redirect_to(edit_user_merchant_path) }
    end

    describe "GET :edit" do
      before do
        get :edit
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/merchants/edit') }
      it { should assign_to(:merchant).with(merchant) }
    end

    describe "PUT :update" do
      describe "successfully" do
        before do
          AdminMailer.should_receive(:update_merchant).with(merchant).and_return(double(:deliver => true))
          merchant.should_receive(:update_attributes).with(params).and_return(true)
          put :update, :merchant => params
        end

        it { should set_the_flash.to("Your merchant profile has been updated.") }
        it { should redirect_to(edit_user_merchant_path) }
      end

      describe "unsuccessfully" do
        before do
          merchant.should_receive(:update_attributes).with(params).and_return(false)
          put :update, :merchant => params
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/merchants/edit') }
        it { should assign_to(:merchant).with(merchant) }
      end
    end
  end

  describe "for a user with no merchant" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:merchant).and_return(nil)

      sign_in(user)
    end

    describe "GET :new" do
      before do
        Merchant.should_receive(:new).and_return(merchant)
        merchant.should_receive(:build_address)

        get :new
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/merchants/new') }
      it { should assign_to(:merchant).with(merchant) }
    end

    describe "POST :create" do
      before do
        user.should_receive(:build_merchant).with(params).and_return(merchant)
      end

      describe "successfully" do
        before do
          merchant.should_receive(:save).and_return(true)

          post :create, :merchant => params
        end

        it { should set_the_flash.to("Your merchant has been created and has been submitted for review by our team.") }
        it { should redirect_to(edit_user_merchant_path) }
      end

      describe "unsuccessfully" do
        before do
          merchant.should_receive(:save).and_return(false)
          post :create, :merchant => params
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/merchants/new') }
        it { should assign_to(:merchant).with(merchant) }
      end
    end

    describe "GET :edit" do
      before do
        get :edit
      end

      it { should redirect_to(new_user_merchant_path) }
    end

    describe "PUT :update" do
      before do
        put :update
      end

      it { should redirect_to(new_user_merchant_path) }
    end
  end
end
