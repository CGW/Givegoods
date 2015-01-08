require 'spec_helper'

describe 'layouts/bootstrap/users' do
  let(:user) { mock_model(User, :charity => nil, :merchant => nil) }

  before do
    view.stub(:user_signed_in?).and_return(false)
    view.stub(:current_user).and_return(user)
  end

  it "renders the bootstrap layout" do 
    render
    view.should render_template('layouts/bootstrap/application')
  end

  describe 'content_for :content' do
    describe "for a user with no role" do
      before do
        user.stub(:role).and_return(nil)
        render
      end

      it "renders menu partial" do
        view.should render_template(:partial => 'layouts/bootstrap/users/_no_role_menu')
      end
    end

    describe "for a charity user" do
      before do
        user.stub(:role).and_return('charity')
        render
      end

      it "renders messages partial" do
        view.should render_template(:partial => 'layouts/bootstrap/users/_charity_messages')
      end

      it "renders menu partial" do
        view.should render_template(:partial => 'layouts/bootstrap/users/_charity_menu')
      end
    end

    describe "for a merchant user" do
      before do
        user.stub(:role).and_return('merchant')
        render
      end

      it "renders messages partial" do
        view.should render_template(:partial => 'layouts/bootstrap/users/_merchant_messages')
      end

      it "renders menu partial" do
        view.should render_template(:partial => 'layouts/bootstrap/users/_merchant_menu')
      end
    end
  end
end
