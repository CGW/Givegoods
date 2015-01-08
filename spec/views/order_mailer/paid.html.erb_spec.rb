require 'spec_helper'

describe "order_mailer/paid" do
  let!(:customer) { create(:customer_with_order) }
  let!(:order) { customer.orders.first }

  before do
    assign(:order, order)
    assign(:certificates, [])
    assign(:charities, order.charities)
    assign(:deals, order.deals)
    assign(:merchants, order.deals.map(&:merchant_names)).flatten.uniq
  end

  it "has a personal thank you" do
    render
    rendered.should have_content(order.buyer.first_name)
  end

  describe "when certificates were purchased" do
    before do
      assign(:certificates, order.certificates)
    end

    it "shows tax deductible information if donations were made" do
      donation_amount = Money.new(10000)
      order.stub(:donations_total_amount).and_return(donation_amount)
      render

      rendered.should have_content "About Your Tax Deductions and Rewards:"
    end

    it "shows a list of purchased certificates" do
      render
      rendered.should have_content "You have received rewards from"
      order.certificates.each do |certificate|
        rendered.should have_content certificate.merchant.name
        rendered.should have_link "Print certificate", :href => print_certificate_url(certificate)
      end
    end
  end

  it "does not show tax deductible information" do
    render
    rendered.should have_content "About Your Tax Deductions:"
  end

  it "does not show a section for rewards received" do
    render
    rendered.should_not have_content "You have received rewards from"
  end
end
