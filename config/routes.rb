PopUpStores::Application.routes.draw do


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  scope "(:language)", locale: /en|es/ do 
    resources :markets, :only => [:index, :show] do
      collection do
        post :search, action: "search", as: 'search'
        get :search, action: "search"
        get :live_search, action: "live_search", path: "live_search"
      end
      post :publish
      post :publish_anyway
      post :unpublish
      post :archive
      get :make_pro_payment
      post :make_pro
      post :force_make_pro

      resource :statistic, controller: "statistic", :only => [] do
        get :market, :on => :member, :as => "show"
      end

    end

    get "/users/:user_id/dashboard", to: "users#dashboard", as: "user_dashboard"
    get "/users/admin", to: "users#admin", as: "admin"
    get "/users/:user_id/markets", to: "markets#list_user_markets", as: "user_markets"
    get "/published", to: "markets#list_published_markets", as: "published_markets"
    get "/list_recommend_markets", to: "markets#list_recommend_markets", as: "list_recommend_markets"

    resources :users, :only => [:index, :show]

    resources :users do
      resources :markets, only: [:index, :new, :create, :edit, :update, :destroy]

      put :desactivate, :on => :member
      put :activate, :on => :member

      resource :role, controller: "role", :only => [:update] do
        get :change, :on => :member
      end

      resource :status, controller: "status", :only => [:update]

      resource :statistic, controller: "statistic", :only => [] do
        get :user, :on => :member, :as => "show"
      end

    end

    resources :subscriptions, :only => [:create] do

    end

    post "/unsubscribe", to: "subscriptions#unsubscribe", as: "unsubscribe"
    get "/users/:user_id/subscription", to: "users#subscription", as: "user_subscription"

    resource :contact, controller: "contact", :only => [] do
      get :new, :on => :member
      post :create, :on => :member
    end

    resource :statistic, controller: "statistic", :only => [] do
      get :market, :on => :member
    end

    resource :statistic, controller: "statistic", :only => [] do
      get :admin, :on => :member, :as => "show"
    end

    ### Coupons
    resources :coupons, :only => [:show, :index] do
      post :coupon_payment, :on => :member
    end
    post "/coupons/:id", to: "coupons#buy", as: "buy_coupon"
    get "/coupons/:user_id/bought_coupons_by_user", to: "coupons#bought_coupons_by_user", as: "bought_coupons_by_user"
    get "/coupons/:market_id/sold_coupons_by_market", to: "coupons#sold_coupons_by_market", as: "sold_coupons_by_market"
    ###

    ### Wishes
    get "/wishes/gallery", as: "wishes_gallery"
    get "/users/:user_id/wishes", to: "wishes#list_user_wishes", as: "user_wishes"
    post "/wishes/:id/recommend/:market_id", to: "wishes#recommend", as: "recommend_market_to_wish"
    resources :wishes
    ####

    ### Bargains
    get "/bargains/gallery", as: "bargains_gallery"
    get "/users/:user_id/bargains", to: "bargains#list_user_bargains", as: "user_bargains"
    resources :bargains
    ####

    ### Likes
    get "/likes/:user_id", to: "markets#list_liked_markets", as: "user_likes"
    get "/like/:market_id",  to: 'users#like', as: 'like'
    get "/unlike/:market_id",  to: 'users#unlike', as: 'unlike'
    ####

    #### Edit photos
    get "/photos/:id/edit", to: "photos#edit", as: 'edit_photo'
    post "/photos/:id/crop", to: "photos#crop", as: 'crop_photo'
    get "/users/:user_id/photos", to: "photos#list_user_photos", as: "user_photos"
    resources :photos, only: [:show, :index, :destroy]
    resources :gallery, only: [:show]
    ####

    get "/last_markets", to: "markets#list_last_markets", as: "last_markets"
    get "/pro_markets", to: "markets#list_pro_markets", as: "pro_markets"
    get "/slideshow", to: "markets#slideshow", as: "slideshow"

    ### SpecialLocations
    get "/special_locations/list", as: "special_locations_list"
    get "/special_locations/gallery", as: "special_locations_gallery"
    get "/special_locations/get_location", as: "get_location", path: "get_location"
    resources :special_locations
    ####

    ### Tags
    get "/tags/list", as: "tags_list"
    get "/tags/gallery", as: "tags_gallery"
    get "/tags/:tag/markets", to: "markets#list_tag_markets", as: "tag_markets"
    resources :tags
    ####
   
    ### Categories
    get "/categories/list", as: "categories_list"
    get "/categories/gallery", as: "category_gallery"
    get "/category/:category_id/markets", to: "markets#list_category_markets", as: "category_markets"
    resources :categories
    ####

    get "static_pages/map", path: "/map", as: 'map'
    get "static_pages/buy_coupon_terms", as: "buy_coupon_terms"
    get "static_pages/sell_coupon_terms", as: "sell_coupon_terms"
    get "static_pages/privacy", as: "privacy"
    root "static_pages#home"

  end

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount Attachinary::Engine => "/attachinary"

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
