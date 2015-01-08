require 'spec_helper'

describe Users::CharitiesController do
  let(:charity) { mock_model(Charity, :name => 'Alameda Flock Consortium') }
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

  describe "for a user with a charity" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:charity).and_return(charity)

      sign_in(user)
    end

    describe "GET :new" do
      before do
        get :new
      end

      it { should redirect_to(edit_user_charity_path) }
    end

    describe "POST :create" do
      before do
        post :create
      end

      it { should redirect_to(edit_user_charity_path) }
    end

    describe "GET :edit" do
      before do
        get :edit
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/charities/edit') }
      it { should assign_to(:charity).with(charity) }
    end

    describe "PUT :update" do
      describe "successfully" do
        before do
          charity.should_receive(:update_attributes).with(params).and_return(true)
          put :update, :charity => params
        end

        it { should set_the_flash.to("Your charity profile has been updated.") }
        it { should redirect_to(edit_user_charity_path) }
      end

      describe "unsuccessfully" do
        before do
          charity.should_receive(:update_attributes).with(params).and_return(false)
          put :update, :charity => params
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/charities/edit') }
        it { should assign_to(:charity).with(charity) }
      end
    end
  end

  describe "for a user with no charity" do
    before do
      subject.stub(:current_user).and_return(user)
      user.stub(:charity).and_return(nil)

      sign_in(user)
    end

    describe "GET :new" do
      before do
        Charity.should_receive(:new).and_return(charity)
        charity.should_receive(:build_address)

        get :new
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/charities/new') }
      it { should assign_to(:charity).with(charity) }
    end

    describe "POST :create" do
      before do
        user.should_receive(:build_charity).with(params).and_return(charity)
      end

      describe "successfully" do
        before do
          charity.should_receive(:save).and_return(true)
          EmailService.should_receive(:new_charity).and_return(true)

          post :create, :charity => params
        end

        it { should set_the_flash.to("Congratulations, #{charity.name}. Your charity account has been created.") }
        it { should redirect_to(edit_user_charity_path) }
      end

      describe "unsuccessfully" do
        before do
          charity.should_receive(:save).and_return(false)
          post :create, :charity => params
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/charities/new') }
        it { should assign_to(:charity).with(charity) }
      end
    end

    describe "GET :edit" do
      before do
        get :edit
      end

      it { should redirect_to(new_user_charity_path) }
    end

    describe "PUT :update" do
      before do
        put :update
      end

      it { should redirect_to(new_user_charity_path) }
    end
  end
end
