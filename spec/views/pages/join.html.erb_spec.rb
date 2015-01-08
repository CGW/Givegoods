require 'spec_helper'

describe 'pages/join' do
  before do
    render
  end

  it "has link to sign in" do
    rendered.should have_link('sign in', :url => new_user_session_path)
  end

  it "has link to sign up" do
    rendered.should have_link('Create an account', :url => new_user_registration_path)
  end

  it "has links for more information" do
    rendered.should have_link('learn more', :url => page_path('merchant_info'))
    rendered.should have_link('learn more', :url => page_path('charity_info'))
  end
end

