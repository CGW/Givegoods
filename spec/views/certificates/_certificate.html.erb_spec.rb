require 'spec_helper'

describe 'certificates/_certificate' do
  let(:certificate) { create(:certificate) }
  let(:merchant)    { certificate.merchant }

  before do
    assign(:certificate, certificate)
  end

  it "displays the certificate" do
    render :partial => 'certificates/certificate', :locals => { :certificate => certificate }

    offer_value = certificate.offer_value.format(:no_cents_if_whole => true) 
    offer_cap = certificate.offer_cap.format(:no_cents_if_whole => true)

    rendered.should have_selector('div.certificate-print')

    # top right code
    rendered.should have_selector('div.code', :text => certificate.code)

    # headers
    rendered.should have_content(offer_value)
    rendered.should have_content(merchant.name)

    # tagline/description
    rendered.should have_content(certificate.tagline)
    rendered.should have_content("Get #{offer_value} when you spend #{offer_cap}, or take #{certificate.discount_rate}% off smaller purchases.")

    # adddress/website
    address = merchant.address
    rendered.should have_content(address.street)
    rendered.should have_content(address.city)
    rendered.should have_content(address.state.code)
    rendered.should have_content(merchant.website_host)

    # thanks
    rendered.should have_content("Thank you for supporting #{certificate.charity.name}")

    # purchased
    rendered.should have_content("This certificate was purchased on #{certificate.created_at.strftime('%m-%d-%Y')}")

    # rules
    rendered.should have_content(certificate.rules)
  end

  it "does not display the offer rules when nil" do
    certificate.rules = nil 
    render :partial => 'certificates/certificate', :locals => { :certificate => certificate }

    rendered.should_not have_content(merchant.offer.rules)
  end
end
