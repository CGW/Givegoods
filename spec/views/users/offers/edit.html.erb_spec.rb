require 'spec_helper'

describe 'users/offers/edit' do
  let(:merchant) { double('Merchant', :active? => false) }
  let(:offer) { create(:offer) }

  before do
    assign(:offer, offer)
    assign(:merchant, merchant)
  end

  it "has title" do
    render
    rendered.should have_selector('h1', :text => 'Reward settings')
  end

  it "renders the offer form" do
    render
    view.should render_template(:partial => 'users/offers/_form')
  end
end

