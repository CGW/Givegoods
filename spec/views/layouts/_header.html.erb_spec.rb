require 'spec_helper'

describe 'layouts/_header' do
  before do 
    view.stub(:user_signed_in?).and_return(false)
  end

  describe "when the user is not signed in" do
    before do
      render
    end

    it "has a link to join" do
      rendered.should have_link('Join', :href => page_path('join')) 
    end

    it "has a link to sign-in" do
      rendered.should have_link('Join', :href => page_path('join')) 
    end

    it "does not have link to logout" do
      rendered.should_not have_link('Log out', :href => destroy_user_session_path)
    end

    it "does not have link to account" do
      rendered.should_not have_link('My Account', :href => edit_user_registration_path)
    end
  end

  describe "when the user is signed in" do
    before do
      view.stub(:user_signed_in?).and_return(true)
      render
    end

    it "has a link to logout" do
      rendered.should have_link('Log out', :href => destroy_user_session_path)
    end

    it "has a link to account" do
      rendered.should have_link('My Account', :href => edit_user_registration_path)
    end

    it "does not have link to join" do
      rendered.should_not have_link('Join', :href => page_path('join')) 
    end

    it "does not have link to sign-in" do
      rendered.should_not have_link('Join', :href => page_path('join')) 
    end
  end
end
