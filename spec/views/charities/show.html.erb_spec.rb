require 'spec_helper'

describe 'charities/show' do
  let(:charities) { create_list(:charity, 3) }
  let(:charity)   { charities.first }
  let(:merchant)  { create(:offer).merchant }

  before do
    assign(:charities, charities)
    assign(:charity, charity)
    assign(:merchant, merchant)
    render
  end

  it "should render charities/index" do
    view.should render_template("charities/index")
  end

  it "should render shared/grid/new" do
    view.should render_template("shared/grid/_new")
  end
end
