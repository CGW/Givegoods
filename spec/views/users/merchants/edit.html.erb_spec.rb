require 'spec_helper'

describe 'users/merchants/edit' do
  let(:merchant) { create(:merchant) }

  before do
    assign(:merchant, merchant)
    render
  end

  it "has title" do
    rendered.should have_selector('h1', :text => 'Merchant profile')
  end

  describe "when the merchant is active" do
    before do
      merchant.stub(:active?).and_return(true)
      render
    end

    it "has a link to their public profile" do
      rendered.should have_link('View public page', :url => merchant_charities_path(merchant))
    end
  end

  it "renders the merchant form" do
    view.should render_template(:partial => 'users/merchants/_form')
  end
end

