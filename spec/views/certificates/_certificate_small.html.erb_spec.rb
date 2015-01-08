require 'spec_helper'

describe 'certificates/_certificate_small' do
  let(:certificate) { create(:certificate) }
  let(:merchant)    { certificate.merchant }

  before do
    assign(:certificate, certificate)
  end

  it "displays a small certificate" do
    render :partial => 'certificates/certificate_small', :locals => { :certificate => certificate }

    rendered.should have_content(certificate.offer_value.format(:no_cents_if_whole => true))
    rendered.should have_content(certificate.merchant.name)
    rendered.should have_content(certificate.tagline)

    rendered.should have_selector('a', :text => 'Print Certificate')
    rendered.should have_link('a', :href => print_certificate_path(certificate))
  end
end
