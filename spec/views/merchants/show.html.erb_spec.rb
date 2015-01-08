require 'spec_helper'

describe 'merchants/show' do
  let(:merchants) { create_list(:offer, 3).map(&:merchant) }
  let(:merchant)  { merchants.first }
  let(:charity)   { create(:charity) }

  before do
    assign(:merchants, merchants)
    assign(:merchant, merchant)
    assign(:charity, charity)
    render
  end

  it "should render merchants/index" do
    view.should render_template("merchants/index")
  end

  it "should render shared/grid/new" do
    view.should render_template("shared/grid/_new")
  end
end
