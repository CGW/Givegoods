require 'spec_helper'

describe CharitiesController do
  let(:merchant)      { mock_model(Merchant) }
  let(:charity)       { mock_model(Charity, :name => 'ARC') }
  let(:charity_scope) { stub('CharityScope') }

  describe "GET :show" do
    before do 
      # Stub out the before filter find_charities
      subject.should_receive(:find_charities).and_return(true)

      # find_merchant
      Merchant.stub_chain(:with_active_offer, :find).and_return(merchant)

      Charity.should_receive(:active).and_return(charity_scope)
      charity_scope.should_receive(:find).with(charity.id.to_s).and_return(charity)
    end
    
    describe 'with a merchant' do
      before do
        get :show, :id => charity.id, :merchant_id => merchant.id
      end

      it { should respond_with(:success) }
      it { should render_template('charities/show') }
      it { should assign_to(:title).with("#{charity.name} :: #{I18n.t("site.title")}") }
      it { should assign_to(:charity).with(charity) }
    end

    describe 'without a merchant' do
      before do
        get :show, :id => charity.id
      end

      it { should redirect_to(charities_path) }
    end
  end

  describe "GET :landing" do
    before do
      Charity.should_receive(:active).and_return(charity_scope)
      charity_scope.should_receive(:includes).with(:campaign).and_return(charity_scope)
      charity_scope.should_receive(:find).with(charity.id.to_s).and_return(charity)

      get :landing, :id => charity.id
    end

    it { should respond_with(:success) }
    it { should render_template('charities/landing') }
    it { should assign_to(:title).with("#{charity.name} :: #{I18n.t("site.title")}") }
    it { should assign_to(:charity).with(charity) }
  end

  describe "GET :search" do
    let!(:charities)  { create_list(:active_charity, 3) }

    describe "by geo location" do
      describe "with a valid params[:place]" do
        before do
          # Charity that is far away and should not be returned
          create(:active_charity, :lat => 3, :lng => 10)

          get :search, :place => "Alameda, CA"
        end

        it { should respond_with(:success) }
        it { should render_template('charities/index') }
        it "should assign charities" do
          assigns(:charities).to_set.should eq(charities.to_set)
        end
      end

      describe "with invalid params[:place]" do
        before do
          get :search, :place => "Mines of Moria"
        end

        it { should render_template('charities/index') }
        it { should assign_to(:charities).with([]) }
      end
    end

    describe "by name" do
      let!(:charity) { create(:active_charity, :name => "Biggly's Toys for Tots") }

      before do
        get :search, :name => 'biggly'
      end

      it { should render_template('charities/index') }
      it { should assign_to(:charities).with([charity]) }
    end
  end
end
