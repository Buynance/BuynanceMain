Buynance::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope(:path_names => { :new => "merchant-cash-advance" }) do
    resources :profitabilities, :path => "calculator", :only => [:new, :create]
  end

  resources :static_pages, :except => [:new, :create, :show, :update, :destroy, :index, :edit]
  
  resources :businesses, :only => [:new, :create, :show], :path => "clients" do
    resources :offers, :only => [:index] do
      patch :accept
    end
    member do
      patch :activate
    end
  end
  
  mount API::Base => '/api'
  #resource :business, :as => 'account'  # a convenience route
  scope(:path_names => { :past_merchants => "funders", :financial_information => "financial" }) do
    resources :business_steps, :path => "register"
  end
  resources :after_offers, :path => "submit"
  resources :business_user_sessions, :path => "session", :only => [:new, :create, :destoy]
  #resources :calculator, :controller => "profitabilities", :path_names => { :new => "merchant-cash-advance" }

  get 'login' => "business_user_sessions#new",      :as => :login
  get 'logout' => "business_user_sessions#destroy", :as => :logout

  get 'signup' => 'businesses#new', :as => :signup
  get 'account' => 'businesses#show'

  #get 'activate_account' => 'businesses#activate_account'

  get 'tos'                   => 'static_pages#tos'
  get 'privacy'               => 'static_pages#privacy'
  get 'merchant-cash-advance' => 'static_pages#merchantcashadvance'
  get 'blog'                  => 'static_pages#blog'

  match 'activate/:activation_code' => "businesses#activate", via: :get

  get '/offers/:offer_id/accept' => 'offers#accept'
  put '/offers/:offer_id/update' => 'offers#update'

  post 'user/recover_account'    => 'business_users#recover_account'
  post 'user/reset_password'     => "business_users#reset_password"
  get 'recover'                  => 'business_users#recover', :as => :recovery_path
  get 'activation'               => 'business_users#recovery_instructions', :as => :recovery_instructions_path
  match 'recover/:recovery_code' => "business_users#password", via: :get
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
