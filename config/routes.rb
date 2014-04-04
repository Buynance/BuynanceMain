Buynance::Application.routes.draw do
  get "activations/create"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope(:path_names => { :new => "merchant-cash-advance" }) do
    resources :profitabilities, :path => "calculator"
  end
  resources :static_pages
  resources :businesses

  resources :offers
  resource :business, :as => 'account'  # a convenience route
  scope(:path_names => { :past_merchants => "funders", :financial_information => "financial" }) do
    resources :business_steps, :path => "register"
  end
  resources :after_offers
  resources :funders
  resources :business_sessions
  #resources :calculator, :controller => "profitabilities", :path_names => { :new => "merchant-cash-advance" }

  get 'login' => "business_sessions#new",      :as => :login
  get 'logout' => "business_sessions#destroy", :as => :logout


  get 'signup' => 'businesses#new', :as => :signup
  get 'account' => 'businesses#show'
  get 'activate_account' => 'businesses#activate_account'

  get 'tos' => 'static_pages#tos'
  get 'privacy' => 'static_pages#privacy'
  get 'merchant-cash-advance' => 'static_pages#merchantcashadvance'
  get 'blog' => 'static_pages#blog'
  match 'activate/:activation_code' => "businesses#activate", via: :get
  get 'recover' => 'businesses#recover', :as => :recovery_path
  match 'recover/:recovery_code' => "businesses#password", via: :get
  match 'business/:business_id/confirm/:confirmation_code' => "business#confirm_account", via: :get
  match 'business/:business_id/confirm/:activation_code' => "business#activation_account", via: :get
  put '/business/insert/:id' => 'businesses#insert'
  get '/business/accept_offer/:id' => 'businesses#accept_offer'
  put '/offer/update/:id' => 'offers#update'
  post 'businesses/recover_account'
  post 'businesses/reset_password' => "businesses#reset_password"
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
