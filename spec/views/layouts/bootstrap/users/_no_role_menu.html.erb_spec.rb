require 'spec_helper'

describe 'layouts/bootstrap/users/_no_role_menu' do
  let(:user)     { mock_model(User) }
  let(:charity)  { mock_model(Charity) }
  let(:campaign) { mock_model(Campaign) }

  before do
    view.stub(:current_user).and_return(user)
    render
  end

  it "shows the charity profile link" do
    rendered.should have_link('Finish setup', :url => new_user_role_assignment_path)
  end

  it "shows the account settings link" do
    rendered.should have_link('Account settings', :url => edit_user_registration_path)
  end
end
