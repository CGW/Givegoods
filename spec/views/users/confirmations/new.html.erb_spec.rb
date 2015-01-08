require 'spec_helper'

describe 'users/confirmations/new' do
  include_context 'devise view'

  before do
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Resend confirmation')
  end

  it "has user confirmation form" do
    rendered.should have_selector("form", :method => "post",
                                  :action => user_confirmation_path)

    rendered.should have_field('user[email]')
    rendered.should have_button('Resend confirmation')
  end
end
