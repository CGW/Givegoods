require 'spec_helper'

describe Users::SessionsController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET :new" do
    before do
      get :new
    end

    it { should respond_with(:success) }
    it { should render_template('layouts/bootstrap/application') }
    it { should render_template('users/sessions/new') }
  end

  describe "POST :create" do
    describe "successfully" do
      let(:user) { create(:user) } 

      before do
        post :create, :user_session => { :email => user.email, :password => 'change-this'}
      end

      it { should respond_with(:redirect) }
    end

    describe "unsuccessfully" do
      before do
        post :create
      end

      it { should render_template('layouts/bootstrap/application') }
      it { should render_template('users/sessions/new') }
    end
  end

end
