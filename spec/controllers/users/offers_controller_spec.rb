require 'spec_helper'

describe Users::OffersController do
  let(:user)    { create(:user) }
  let(:params)  { {'hi' => 'mate'} }

  describe "for anonymous users" do
    it "GET :new redirects" do
      get :new
      subject.should redirect_to(user_session_path)
    end

    it "POST :create redirects" do
      post :create
      subject.should redirect_to(user_session_path)
    end

    it "GET :edit redirects" do
      get :edit
      subject.should redirect_to(user_session_path)
    end

    it "PUT :update redirects" do
      put :update
      subject.should redirect_to(user_session_path)
    end
  end

  describe "for a user without a merchant" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:merchant).and_return(nil)

      sign_in(user)
    end

    describe "users are redirected to new merchant path" do
      it "GET :new" do
        get :new
        subject.should redirect_to(new_user_merchant_path)
      end

      it "POST :create" do
        post :create
        subject.should redirect_to(new_user_merchant_path)
      end

      it "GET :edit " do
        get :edit
        subject.should redirect_to(new_user_merchant_path)
      end

      it "PUT :update" do
        put :update
        subject.should redirect_to(new_user_merchant_path)
      end
    end
  end

  describe "for a user with a merchant" do
    let(:merchant) { mock_model(Merchant) }
    let(:offer)    { mock_model(Offer) }

    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:merchant).and_return(merchant)

      sign_in(user)
    end

    describe "with an offer" do
      before do
        merchant.stub(:offer).and_return(offer)
      end

      describe "GET :new" do
        before do
          get :new
        end

        it { should redirect_to(edit_user_merchant_offer_path) }
      end

      describe "POST :create" do
        before do
          post :create
        end

        it { should redirect_to(edit_user_merchant_offer_path) }
      end

      describe "GET :edit" do
        before do
          get :edit
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/offers/edit') }
        it { should assign_to(:merchant).with(merchant) }
        it { should assign_to(:offer).with(offer) }
      end

      describe "PUT :update" do
        describe "successfully" do
          before do
            offer.should_receive(:update_attributes).with(params).and_return(true)
            put :update, :offer => params
          end

          it { should set_the_flash.to("Your reward settings have been updated.") }
          it { should redirect_to(edit_user_merchant_offer_path) }
        end

        describe "unsuccessfully" do
          before do
            offer.should_receive(:update_attributes).with(params).and_return(false)
            put :update, :offer => params
          end

          it { should respond_with(:success) }
          it { should render_template('layouts/bootstrap/users') }
          it { should render_template('users/offers/edit') }
          it { should assign_to(:offer).with(offer) }
          it { should assign_to(:merchant).with(merchant) }
        end
      end
    end

    describe "without an offer" do
      before do
        merchant.stub(:offer).and_return(nil)
      end

      describe "GET :new" do
        before do
          merchant.stub(:build_offer).and_return(offer)
          get :new
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/offers/edit') }
        it { should assign_to(:merchant).with(merchant) }
        it { should assign_to(:offer).with(offer) }
      end

      describe "POST :create" do
        before do
          merchant.should_receive(:build_offer).with(params).and_return(offer)
        end

        describe "successfully" do
          before do
            offer.should_receive(:save).and_return(true)
            post :create, :offer => params
          end

          it { should set_the_flash.to("Your reward has been successfully created.") }
          it { should redirect_to(edit_user_merchant_offer_path) }
        end

        describe "unsuccessfully" do
          before do
            offer.should_receive(:save).and_return(false)
            post :create, :offer => params
          end

          it { should respond_with(:success) }
          it { should render_template('layouts/bootstrap/users') }
          it { should render_template('users/offers/edit') }
          it { should assign_to(:merchant).with(merchant) }
          it { should assign_to(:offer).with(offer) }
        end
      end

      describe "GET :edit" do
        before do
          get :edit
        end

        it { should redirect_to(new_user_merchant_offer_path) }
      end

      describe "PUT :update" do
        before do
          put :update
        end

        it { should redirect_to(new_user_merchant_offer_path) }
      end
    end
  end

end

