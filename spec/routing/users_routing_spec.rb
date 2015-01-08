require 'spec_helper'

describe 'users routing' do
  let(:user) { create(:user) } 
  
  describe 'role selection' do
    it 'routes GET /users/setup/new' do
      get('/users/setup/new').should route_to(
        :controller => 'users/role_assignments',
        :action     => 'new'
      )
    end

    it 'routes POST /users/setup' do
      post('/users/setup').should route_to(
        :controller => 'users/role_assignments',
        :action     => 'create'
      )
    end
  end

  describe 'confirmations' do
    it 'routes GET /users/confirmation/new' do
      get('/users/confirmation/new').should route_to(
        :controller => 'users/confirmations',
        :action     => 'new'
      )
    end
    it 'routes POST /users/confirmation' do
      post('/users/confirmation').should route_to(
        :controller => 'users/confirmations',
        :action     => 'create'
      )
    end
    it 'routes GET /users/confirmation/sent' do
      get('/users/confirmation/sent').should route_to(
        :controller => 'users/confirmations',
        :action     => 'sent'
      )
    end
  end

  describe 'passwords' do
    it 'routes GET /users/password/new' do
      get('/users/password/new').should route_to(
        :controller => 'users/passwords',
        :action     => 'new'
      )
    end

    it 'routes POST /users/password' do
      post('/users/password').should route_to(
        :controller => 'users/passwords',
        :action     => 'create'
      )
    end
  end

  describe 'charity' do
    [:new, :edit].each do |action|
      it "routes GET /users/charity/#{action}" do
        get("/users/charity/#{action}").should route_to(
          :controller => 'users/charities',
          :action     => action.to_s
        )
      end
    end

    it 'routes POST /users/charity' do
      post('/users/charity').should route_to(
        :controller => 'users/charities',
        :action     => 'create'
      )
    end

    it 'routes PUT /users/charity' do
      put('/users/charity').should route_to(
        :controller => 'users/charities',
        :action     => 'update'
      )
    end
  end

  describe 'campaign' do
    it "routes GET /users/campaign/edit" do
      get("/users/campaign/edit").should route_to(
        :controller => 'users/campaigns',
        :action     => 'edit'
      )
    end

    it "routes PUT /users/campaign" do
      put("/users/campaign").should route_to(
        :controller => 'users/campaigns',
        :action     => 'update'
      )
    end
  end

  describe 'merchant' do
    [:new, :edit].each do |action|
      it "routes GET /users/merchant/#{action}" do
        get("/users/merchant/#{action}").should route_to(
          :controller => 'users/merchants',
          :action     => action.to_s
        )
      end
    end

    it 'routes POST /users/merchant' do
      post('/users/merchant').should route_to(
        :controller => 'users/merchants',
        :action     => 'create'
      )
    end

    it 'routes PUT /users/merchant' do
      put('/users/merchant').should route_to(
        :controller => 'users/merchants',
        :action     => 'update'
      )
    end

    describe 'offers' do
      [:new, :edit].each do |action|
        it "routes GET /users/merchant/offer/#{action}" do
          get("/users/merchant/offer/#{action}").should route_to(
            :controller => 'users/offers',
            :action     => action.to_s
        )
        end
      end

      it 'routes POST /users/merchant/offer' do
        post('/users/merchant/offer').should route_to(
          :controller => 'users/offers',
          :action     => 'create'
        )
      end

      it 'routes PUT /users/merchant/offer' do
        put('/users/merchant/offer').should route_to(
          :controller => 'users/offers',
          :action     => 'update'
        )
      end
    end

    describe 'certificates' do
      it "routes GET /users/merchant/certificates" do
        get("/users/merchant/certificates").should route_to(
          :controller => 'users/certificates',
          :action     => 'show'
        )
      end

      it 'routes PUT /users/merchant/certificates' do
        put('/users/merchant/certificates').should route_to(
          :controller => 'users/certificates',
          :action     => 'update'
        )
      end
    end
  end
end
