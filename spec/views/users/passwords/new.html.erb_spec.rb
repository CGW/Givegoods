require 'spec_helper'

describe 'users/passwords/new' do
  include_context 'devise view'

  before do
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Forgot your password?')
  end

  it "has password reset form" do
    rendered.should have_form(:method => 'post', :action => user_password_path)
    rendered.should have_field('user[email]')
    rendered.should have_button('Send password reset instructions')
  end
end
