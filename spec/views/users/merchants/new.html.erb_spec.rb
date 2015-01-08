require 'spec_helper'

describe 'users/merchants/new' do
  let(:merchant) { build(:merchant) }

  before do
    merchant.build_address
    assign(:merchant, merchant)
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Create your merchant profile')
  end

  it "renders the merchant form" do
    view.should render_template(:partial => 'users/merchants/_form')
  end
end
