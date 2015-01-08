require 'spec_helper'

describe "certificates/print" do
  let(:certificate) { create(:certificate) }

  before do
    assign(:certificate, certificate)
    render
  end

  it "renders certificate partial" do
    view.should render_template(:partial => 'certificates/_certificate', :count => 1)
  end
  
end
