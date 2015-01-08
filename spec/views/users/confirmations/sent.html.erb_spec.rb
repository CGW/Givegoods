require 'spec_helper'

describe 'users/confirmations/sent' do
  include_context 'devise view'

  before do
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Almost there!')
  end

  it "has a link to resend confirmation" do
    rendered.should have_link('Click here to resend confirmation email', :href => new_user_confirmation_path)
  end

end

