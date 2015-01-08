require 'spec_helper'

describe 'users/sessions/new' do
  include_context 'devise view'

  before do
    render
  end

  it "has a title" do
    rendered.should have_selector('h1', :text => 'Sign in')
  end

  it "has a link to sign-up" do
    rendered.should have_link('Sign up for one.', :url => new_user_registration_path)
  end


  it "has a form to login" do
    rendered.should have_form(:method => 'post', :action => user_session_path)
    rendered.should have_field("Email address")
    rendered.should have_field("Password")
    rendered.should have_field("Remember me?")
  end

  it "has a forgotten password link" do
    rendered.should have_link('Forgot your password?', :url => new_user_password_path)
  end
end
