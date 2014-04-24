PopUpStores::Application.routes.draw do

  resources :special_locations

  get "tags/index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :markets, :only => [:index, :show , :delete_image] do
    collection do
      get :search, action: "search", as: 'search'
      get :published
    end
    post :publish
    post :archive
    resources :comments, :only => [:create, :destroy, :update]
    resources :coupons, :only => [:create, :new]
  end

  resources :coupons, :only => [:show, :index]


  post "/coupons/:id", to: "coupons#buy", as: "buy_coupon"
  get "/coupons/:user_id/in_transactions", to: "coupons#in_transactions", as: "user_in_transactions"
  get "/coupons/:user_id/out_transactions", to: "coupons#out_transactions", as: "user_out_transactions"

  resources :categories, :only => [:index, :new, :destroy, :create]
  resources :users, :only => [:index, :show]
  resources :tags, :only => [:index]

  resources :users do
    resources :markets, only: [:index, :new, :create, :edit, :update, :destroy]

    put :desactivate, :on => :member
    put :activate, :on => :member

    resource :role, controller: "role", :only => [:update] do
      get :change, :on => :member
    end
  end

  get "/users/:user_id/profile", to: "users#profile", as: "user_profile"
  get "/users/:user_id/subscription", to: "users#subscription", as: "user_subscription"

  resources :wishes, except: [:index]
  get "/wishes/index", path: "wishes"
  get "/users/:user_id/wishes", to: "wishes#list_user_wishes", as: "user_wishes"

  post "/markets/:market_id/comments/:id/report", to: "comments#report", as: 'report_comment'
  post "/markets/:market_id/delete_image", to: "markets#delete_image", as: 'delete_image'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount Attachinary::Engine => "/attachinary"

  get "static_pages/search", path: "/search", as: 'search'
  get "static_pages/cities", path: "/cities", as: 'cities'
  get "static_pages/calendar", path: "/calendar", as: 'calendar'
  get "static_pages/map", path: "/map", as: 'map'
  get "/users/:user_id/like/:market_id",  to: 'users#like', as: 'like'
  get "/users/:user_id/unlike/:market_id",  to: 'users#unlike', as: 'unlike'

  root "static_pages#home"

   # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
