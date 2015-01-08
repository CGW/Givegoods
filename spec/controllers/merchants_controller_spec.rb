require 'spec_helper'

describe MerchantsController do

  describe "GET :index" do
    let(:merchants) { Array.new(3) { mock_model(Merchant) } }

    describe "without a charity" do
      before do
        Merchant.stub_chain(:with_active_offer, :includes, :includes, :order).and_return(merchants)
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template('merchants/index') }
      it { should_not assign_to(:charity) }
      it { should assign_to(:merchants).with(merchants) }
      it { should assign_to(:title).with("Rewards :: #{I18n.t('site.title')}") }
    end


    describe "with a charity" do
      let(:charity)  { mock_model(Charity) }
      let(:bundles) { [mock_model(Bundle)] }

      before do
        charity_scope = double('CharityScope')
        Charity.should_receive(:active).and_return(charity_scope)
        charity_scope.should_receive(:find).with(charity.id.to_s).and_return(charity)

        charity.stub_chain(:bundles, :includes, :order, :active).and_return(bundles)
        charity.stub_chain(:merchants, :with_active_offer, :includes, :includes, :order).and_return(merchants)

        get :index, :charity_id => charity.id
      end

      it { should respond_with(:success) }
      it { should render_template('merchants/index') }
      it { should assign_to(:charity).with(charity) }
      it { should assign_to(:bundles).with(bundles) }
      it { should assign_to(:merchants).with(merchants) }
      it { should assign_to(:title).with("#{charity.name} :: #{I18n.t('site.title')}") }
    end
  end

  # TODO: Fix these tests so that they used method stubs instead and possibly
  # move this style of test (create data and test results) to the request
  # specs.  Ideally, the functionliaty of each method
  # (Merchant#with_sufficient_budget, close_to, etc) should be tested in the
  # model specs.
  describe "GET :search" do
    let!(:offers)    { create_list(:offer, 3) }
    let!(:merchants) { offers.map(&:merchant) }

    describe "by geo location" do
      describe "with a valid params[:place]" do
        before do
          out_of_range_offer = create(:offer)
          out_of_range_offer.merchant.tap do |m|
            m.lat = 25
            m.lng = 100
          end.save!

          get :search, :place => "Alameda, CA"
        end

        it { should respond_with(:success) }
        it { should render_template('merchants/index') }
        it "should assign merchants" do
          assigns(:merchants).to_set.should eq(merchants.to_set)
        end
      end

      describe "with invalid params[:place]" do
        before do
          get :search, :place => "Mines of Moria"
        end

        it { should render_template('merchants/index') }
        it { should assign_to(:merchants).with([]) }
      end
    end

    describe "by name" do
      let!(:offer) { create(:offer) }

      before do
        offer.merchant.update_attributes!(:name => "La Penca Azul")
        get :search, :name => 'penca'
      end

      it { should render_template('merchants/index') }
      it { should assign_to(:merchants).with([offer.merchant]) }
    end
  end
end
