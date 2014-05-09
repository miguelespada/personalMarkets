PopUpStores::Application.routes.draw do


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :markets, :only => [:index, :show , :delete_image] do
    collection do
      post :search, action: "search", as: 'search'
      get :search, action: "search"
    end
    post :publish
    post :publish_anyway
    post :unpublish
    post :archive
    get :make_pro_payment
    post :make_pro
    resources :comments, :only => [:create, :destroy, :update]
  end

  get "/users/:user_id/dashboard", to: "users#dashboard", as: "user_dashboard"
  get "/users/admin", to: "users#admin", as: "admin"
  get "/users/:user_id/markets", to: "markets#list_user_markets", as: "user_markets"
  get "/published", to: "markets#list_published_markets", as: "published_markets"
  get "/last_markets", to: "markets#list_last_markets", as: "last_markets"
  get "/explore_slideshows", to: "markets#explore_slideshows", as: "explore_slideshows_markets"

  resources :coupons, :only => [:show, :index] do
    post :coupon_payment, :on => :member
  end

  resources :users, :only => [:index, :show]

  resources :users do
    resources :markets, only: [:index, :new, :create, :edit, :update, :destroy]

    put :desactivate, :on => :member
    put :activate, :on => :member

    resource :role, controller: "role", :only => [:update] do
      get :change, :on => :member
    end

    resource :status, controller: "status", :only => [:update]

  end

  resources :subscriptions, :only => [:create]
  
  resource :contact, controller: "contact", :only => [] do
    get :new, :on => :member
    post :create, :on => :member
  end

  get "/users/:user_id/subscription", to: "users#subscription", as: "user_subscription"

  ### Coupons
  resources :coupons, :only => [:show, :index]
  post "/coupons/:id", to: "coupons#buy", as: "buy_coupon"
  get "/coupons/:user_id/bought_coupons_by_user", to: "coupons#bought_coupons_by_user", as: "bought_coupons_by_user"
  get "/coupons/:market_id/sold_coupons_by_market", to: "coupons#sold_coupons_by_market", as: "sold_coupons_by_market"
  ###

  ### Wishes
  get "/wishes/index", path: "wishes"
  get "/wishes/gallery", as: "wishes_gallery"
  get "/users/:user_id/wishes", to: "wishes#list_user_wishes", as: "user_wishes"
  resources :wishes, except: [:index]
  ####

  ### Bargains
  get "/bargains/index", path: "bargains"
  get "/bargains/gallery", as: "bargains_gallery"
  get "/users/:user_id/bargains", to: "bargains#list_user_bargains", as: "user_bargains"
  resources :bargains, except: [:index]
  ####

  ### SpecialLocations
  get "/explore_hotspots", to: "special_locations#explore_hotspots", as: "explore_hotspots"
  get "/special_locations/gallery", as: "special_locations_gallery"
  resources :special_locations
  ####

  ### Tags
  get "/explore_tags", to: "tags#explore_tags", as: "explore_tags"
  get "/tags/gallery", as: "tags_gallery"
  get "/tags/:tag/markets", to: "markets#list_tag_markets", as: "tag_markets"
  resources :tags
  ####
 
  ### Categories
  get "/explore_categories", to: "categories#explore_categories", as: "explore_categories"
  get "/categories/gallery", as: "category_gallery"
  get "/category/:category_id/markets", to: "markets#list_category_markets", as: "category_markets"
  resources :categories
  ####

  ### Likes
  get "/likes/:user_id", to: "markets#list_liked_markets", as: "user_likes"
  get "/users/:user_id/like/:market_id",  to: 'users#like', as: 'like'
  get "/users/:user_id/unlike/:market_id",  to: 'users#unlike', as: 'unlike'
  ####

  post "/markets/:market_id/comments/:id/report", to: "comments#report", as: 'report_comment'
  post "/markets/:market_id/delete_image", to: "markets#delete_image", as: 'delete_image'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount Attachinary::Engine => "/attachinary"

  get "static_pages/cities", path: "/cities", as: 'cities'
  get "static_pages/calendar", path: "/calendar", as: 'calendar'
  get "static_pages/map", path: "/map", as: 'map'

  #### Edit photos
  get "/photos/:id/edit", to: "photos#edit", as: 'edit_photo'
  ####


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
