require 'spec_helper'

describe 'users/passwords/edit' do
  include_context 'devise view'

  before do
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Change your password')
  end

  it "has change password form" do
    rendered.should have_xpath("//form[@method='post' and @action='#{user_password_path}']")

    rendered.should have_hidden_field('user[reset_password_token]')

    rendered.should have_field('New password')
    rendered.should have_field('Confirm new password')

    rendered.should have_button('Change my password')
  end
end
