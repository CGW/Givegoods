require 'spec_helper'

describe Users::RegistrationsController do
  let(:user) { create(:user) }
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET :new" do
    before do
      get :new
    end

    it { should respond_with(:success) }
    it { should render_template('layouts/bootstrap/application') }
    it { should render_template('users/registrations/new') }
    it { should assign_to(:title).with("Sign Up :: #{I18n.t("site.title")}") }
  end

  describe "POST :create" do
    describe "unsuccessfully" do
      before do
        post :create, "user" => {} 
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/application') }
      it { should render_template('users/registrations/new') }
      it { should assign_to(:title).with("Sign Up :: #{I18n.t("site.title")}") }
    end

    describe "successfully" do
      # We can't get too detailed with this one unless we want to validate
      # that the records were created (should change anybody?), but then we're testing Devise
      # internals. 
      before do
        post :create, "user" => {
          "first_name"            => "Andrew",
          "last_name"             => "Smith",
          "email"                 => "asmith@example.com",
          "password"              => "123456",
          "password_confirmation" => "123456",
          "terms"                 => "1",
        }
      end

      it { should redirect_to(user_confirmation_sent_path) }
    end
  end

  describe "GET :edit" do
    describe "for a valid user" do
      before do
        sign_in user
        get :edit
      end

      it { should respond_with(:success) }
      it { should render_template('layouts/bootstrap/users') }
      it { should render_template('users/registrations/edit') }
      it { should assign_to(:user).with(user) }
    end

    it "redirects anonymous users" do
      get :edit
      response.should redirect_to(user_session_path)
    end
  end

  describe "PUT :upate" do
    describe "for a valid user" do
      before do
        sign_in user
      end

      describe "unsuccessfully" do
        before do
          put :update, "user" => {} 
        end

        it { should respond_with(:success) }
        it { should render_template('layouts/bootstrap/users') }
        it { should render_template('users/registrations/edit') }
      end

      describe "successfully" do
        # We can't get too detailed with this one unless we want to validate
        # that the records were created (should change anybody?), but then we're testing Devise
        # internals. 
        before do
          put :update, "user" => {
            "first_name"       => 'Ricky',
            "last_name"        => 'Williams',
            "email"            => user.email,
            "current_password" => 'change-this'
          }
        end

        it { should redirect_to(edit_user_registration_path) }
      end
    end

    it "redirects anonymous users" do
      put :update
      response.should redirect_to(user_session_path)
    end
  end

end
