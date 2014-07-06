Buynance::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope(:path_names => { :new => "merchant-cash-advance" }) do
    resources :profitabilities, :path => "calculator", :only => [:new, :create]
  end

  resources :static_pages, :except => [:new, :create, :show, :update, :destroy, :index, :edit] do
    collection do
      get 'about'
      get 'offer'
      get 'tos'
      get 'confirm_email'

    end
  end
  
  resources :funder_dashboards, only: [:main, :make_offer, :pending_bids, :accepted_bids, :lost_bids, :won_bids], path: "funder_dashboard" do
    collection do
      get 'main'
      post 'make_offer'
      get 'pending_bids'
      get 'accepted_bids'
      get 'lost_bids'
      get 'won_bids'
    end
  end

  resources :businesses, :only => [:new, :create, :show], :path => "clients" do
    resources :offers, :only => [:index] do
      patch :accept
    end
    resources :bank_accounts
    member do
      patch :activate
    end
    collection do
      get 'show_offers'
      get 'confirm_account'
      post 'confirm_mobile'
    end
  end

  #resources :bank_accounts
  
  mount API::Base => '/api'
  mount Soulmate::Server, :at => "/sm"
  #resource :business, :as => 'account'  # a convenience route
  scope(:path_names => { :past_merchants => "funders", :financial_information => "financial" }) do
    resources :business_steps, :path => "register"
  end

  resources :funders
  resources :funding_steps, :path => "after_signups"
  resources :funder_sessions, :path => "funder_session", :only => [:new, :create, :destoy]
  resources :business_user_sessions, :path => "session", :only => [:new, :create, :destoy]
  
  resources :business_dashboards, :only => [:display_offers, :offer_accepted, :offer_funded, :reenter_market, :accept_offer] do
    collection do
      get "display_offers"
      get "offer_accepted", as: :offer_accepted
      get "offer_funded", as: :offer_funded
      get "reenter_market", as: :reenter_market
      post "accept_offer", as: :accept_offer
    end
  end
  
  get 'offers' => 'business_dashboards#display_offers', as: :display_offers

  resources :funding_steps
  
  #resources :calculator, :controller => "profitabilities", :path_names => { :new => "merchant-cash-advance" }

  get 'login' => "business_user_sessions#new",      :as => :login
  get 'logout' => "business_user_sessions#destroy", :as => :logout
  get 'funder_login' => "funder_sessions#new",      :as => :funder_login
  get 'funder_logout' => "funder_sessions#destroy", :as => :funder_logout


  get 'signup' => 'businesses#new', :as => :signup
  get 'account' => 'businesses#show', :as => :account

  #get 'activate_account' => 'businesses#activate_account'

  get 'tos'                   => 'static_pages#tos'
  get 'privacy'               => 'static_pages#privacy'
  get 'merchant-cash-advance' => 'static_pages#merchantcashadvance'
  get 'blog'                  => 'static_pages#blog'
  get 'about'                 => 'static_pages#about'
 # get 'offer'                 => 'static_pages#offer'
  match 'activate/:activation_code' => "businesses#activate", via: :get
  post 'confirm_mobile' => 'businesses#confirm_mobile'

  get 'details' => 'businesses#details'
  get 'clients/twiml/:id' => 'businesses#twiml'
  
  get 'DLPHP/verification.php' => "bank_accounts#new"
  get '/bank_accounts/success' => "bank_accounts#success"

  get '/offers/:offer_id/accept' => 'offers#accept'
  put '/offers/:offer_id/update' => 'offers#update'

  post 'user/recover_account'    => 'business_users#recover_account'
  post 'user/reset_password'     => "business_users#reset_password"
  get 'recover'                  => 'business_users#recover', :as => :recovery_path
  get 'activation'               => 'business_users#recovery_instructions', :as => :recovery_instructions_path
  match 'recover/:recovery_code' => "business_users#password", via: :get

  post 'call/:id' => 'routing_numbers#call'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  # You can have the root of your site routed with "root"
  root 'static_pages#index'

  get '*path' => redirect('/')
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end



end
