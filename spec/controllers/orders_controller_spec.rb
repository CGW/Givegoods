require 'spec_helper'

describe OrdersController do

  describe "GET :show" do
    let(:purchase_order) { mock_model(MerchantSidekick::PurchaseOrder, :id => '123afxb') }
    let(:certificates)   { Array.new(3) { mock(Certificate) } }
    let(:charities)      { [mock(Charity)] }

    before do
      MerchantSidekick::PurchaseOrder.should_receive(:find, :with => purchase_order.to_param).and_return(purchase_order)

      purchase_order.should_receive(:certificates).and_return(certificates)
      purchase_order.should_receive(:charities).and_return(charities)

      get :show, :id => purchase_order.to_param
    end

    it { should respond_with(:success) }
    it { should render_template('orders/show') }
    it { should assign_to(:order).with(purchase_order) }
    it { should assign_to(:certificates).with(certificates) }
    it { should assign_to(:charities).with(charities) }
  end

end
