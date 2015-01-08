require 'spec_helper'

describe "orders/show" do
  let(:certificate) { create(:certificate) }
  let(:customer) { certificate.customer }

  let(:credit_card) do 
    ActiveMerchant::Billing::CreditCard.new(
      :type       => 'bogus',
      :number     => '1',
      :first_name => customer.first_name,
      :last_name  => customer.last_name
    )
  end

  let(:purchase_order) { customer.purchase([certificate.deal]) }

  before do
    payment = purchase_order.pay(credit_card)  
    payment.success?.should eq(true)

    assign(:order, purchase_order)
    assign(:charities, purchase_order.charities)
  end

  describe "certificates/rewards exist" do
    before do
      assign(:certificates, purchase_order.certificates)
    end

    it "has success text indicating an email has been sent" do
      render 
      rendered.should have_content('You have also been sent an email with a copy of your receipt and links to print out all your certificates.')
    end

    it "renders small certificate partials" do
      render
      view.should render_template(:partial => 'certificates/_certificate_small', :count => purchase_order.certificates.count)
    end

    describe "a donation was made" do
      before do
        purchase_order.stub(:donations_total_amount).and_return(Money.new(2000))
      end

      it "shows the deductions amount" do
        render
        rendered.should have_content "You may deduct the following amount"
        rendered.should have_content purchase_order.donations_total_amount.format
      end
    end
  end

  it "has success text indicating an email has been sent" do
    render 
    rendered.should have_content('You have also been sent an email with a copy of your receipt.')
  end

  it "does not render a certificate partial" do 
    render
    view.should_not render_template(:partial => 'certificates/_certificate_small')
  end

  it "does not show the deductions section" do
    rendered.should_not have_content "You may deduct the following amount"
  end
end
