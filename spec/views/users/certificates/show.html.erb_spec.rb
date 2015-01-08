require 'spec_helper'

describe 'users/certificates/show' do
  let(:certificates)              { Array.new(5) { mock_model(Certificate, :created_at => DateTime.now, :customer => double(:name => 'William Smith')) } }
  let(:certificate_action_filter) { CertificateActionFilter.new }

  before do
    assign(:certificates, [])
    assign(:certificate_action_filter, certificate_action_filter)
  end

  it "has title" do
    render
    rendered.should have_selector('h1', :text => 'Purchase history')
  end

  it "has a form a CertificateActionFilter" do
    render
    rendered.should have_form(:action => user_merchant_certificates_path)

    rendered.should have_select('Mark selected as')
    rendered.should have_input('_update', :type => 'submit', :value => 'Go')

    rendered.should have_select('Filter by status')
    rendered.should have_input('_filter', :type => 'submit', :value => 'Go')
  end

  describe "when there are certificates" do
    before do
      assign(:certificates, certificates)
      certificate_action_filter.stub(:selected?).and_return(false)
      render
    end

    it "has a checkbox for select_all" do
      rendered.should have_unchecked_field('select-all')
    end

    it "renders a row for each certificate" do
      certificates.each do |certificate|
        rendered.should have_input("certificate_action_filter[selected][]", :type => 'checkbox', :value => certificate.id)
        debugger
        [certificate.status, certificate.customer.name, certificate.code, certificate.created_at.to_date.to_s].each do |field|
          rendered.should have_selector("tr td", :text => field)
        end
      end
    end
  end

end

