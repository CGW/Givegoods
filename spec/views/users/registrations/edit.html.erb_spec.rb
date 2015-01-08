require 'spec_helper'

describe 'users/registrations/edit' do
  include_context 'devise view'

  before do
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Account Settings')
  end

  it "has change password form" do
    rendered.should have_xpath("//form[@method='post' and @action='#{user_registration_path}']")

    rendered.should have_field('First name')
    rendered.should have_field('Last name')
    rendered.should have_field('Email address')
    rendered.should have_field('Current password')

    rendered.should have_field('Password')
    rendered.should have_field('Password confirm')

    rendered.should have_button('Update')
  end
end
