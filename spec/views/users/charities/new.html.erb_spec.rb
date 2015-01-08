require 'spec_helper'

describe 'users/charities/new' do
  let(:charity) { build(:charity) }

  before do
    charity.build_address
    assign(:charity, charity)
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Create your charity profile')
  end

  it "renders the charity form" do
    view.should render_template(:partial => 'users/charities/_form')
  end
end
