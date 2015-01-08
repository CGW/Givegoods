GivegoodsSite::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  scope :module => "admin" do
    match '/admin/mailer_previews/:id/show' => 'mailer_previews#show', :as => "show_admin_mailer_preview"
  end

  # Charity landing page redirects from old custom built landing pages.
  match 'amow-donate' => redirect('/charities/alameda-meals-on-wheels-alameda-friendly-visitors')
  match '/pages/amow-donate' => redirect('/charities/alameda-meals-on-wheels-alameda-friendly-visitors')
  match '/pages/support-faas-get-rewards' => redirect('/charities/friends-of-the-alameda-animal-shelter')
  match 'charities/we-love-jan/rewards' => redirect("http://www.givegoods.org/charities/a-fundraiser-for-jan-s-stolen-laptop/rewards")

  resources :merchants, :path => "rewards", :only => [:index, :show] do
    get :search, :on => :collection
    resources :charities, :only => [:index, :show] do
      get :search, :on => :collection
      resource :deals, :only => :create
    end
  end

  resources :charities, :only => [:index] do
    get :search, :on => :collection
    resources :bundles, :only => [:show] do
      resource :deals, :only => :create
    end
    resources :merchants, :path => "rewards", :only => [:index, :show] do
      get :search, :on => :collection
      resource :deals, :only => :create
    end
  end
  # TODO: Refactor charities controller into Shop module to gain control of
  # charity controller back instead of doing this cheat below:
  match '/charities/:id' => 'charities#landing', :via => :get, :as => 'charity_landing' # this should really be charity show
  match '/charities/:charity_id/:id' => "campaigns#show", :via => :get, :as => 'charity_campaign_default'
  match '/charities/:charity_id/campaigns/:id' => "campaigns#show", :via => :get, :as => 'charity_campaign'
  match '/charities/:charity_id/campaigns/:campaign_id/give' => "donation_orders#create", :via => :post, :as => 'charity_campaign_donation_orders'

  resources :certificates, :only => [:print] do
    get :print, :on => :member
  end

  resources :offers, :only => [:index] do
    get :autocomplete_charity_name, :on => :collection
  end

  resources :deals, :only => [:destroy]

  resources :orders, :only => [:new, :create, :show]

  devise_for :users, :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks",
      :registrations      => "users/registrations",
      :confirmations      => "users/confirmations",
      :sessions           => "users/sessions",
      :passwords          => "users/passwords"
  } do
    scope '/users', :module => 'users', :as => 'user' do
      get 'confirmation/sent' => 'confirmations#sent'
      resource :setup, :only => [:new, :create], :controller => 'role_assignments', :as => 'role_assignment'

      resource :charity, :only => [:new, :create, :edit, :update]
      resource :campaign, :only => [:edit, :update]

      resource :merchant, :only => [:new, :create, :edit, :update] do
        resource :certificates, :only => [:show, :update]
        resource :offer, :only => [:new, :create, :edit, :update]
      end
    end
  end

  root :to => 'pages#index'
  match 'home' => 'pages#index'
  match 'pages/:page' => 'pages#show', :as => :page

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
