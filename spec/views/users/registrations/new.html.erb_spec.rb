require 'spec_helper'

describe 'users/registrations/new' do
  include_context 'devise view'

  before do
    # Not happy about having to stub this out completely, need a better solution.
    view.stub(:resource).and_return(resource)
    view.stub(:resource_name).and_return(:user)
    view.stub(:devise_mapping).and_return(mock('DeviseMapping', :rememberable? => true))
  end

  it "has links for more information" do
    render
    rendered.should have_link('merchants', :url => page_path('merchant_info'))
    rendered.should have_link('charities', :url => page_path('charity_info'))
  end

  describe "new user form" do
    it "exists" do
      render 
      rendered.should have_form(:action => user_registration_path)
    end

    it "has fields" do
      render 
      rendered.should have_field("user[first_name]")
      rendered.should have_field("user[last_name]")
      rendered.should have_field("user[email]")
      rendered.should have_field("user[password]")
      rendered.should have_field("user[password_confirmation]")
      rendered.should have_field("user[terms]")
    end

    it "has submit" do
      render
      rendered.should have_button('Sign up')
    end
  end

  it "has a form to login" do
    render 
    rendered.should have_form(:method => 'post', :action => user_session_path)

    rendered.should have_field("user_session[email]")
    rendered.should have_field("user_session[password]")
  end
end
