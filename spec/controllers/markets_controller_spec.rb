require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:user) { create(:user) } 
  let(:market) { build(:market) }
  let(:photo_json) {'[{"public_id":"dummy",
    "version":1,
    "signature":"dummy",
    "width":75,
    "height":75,
    "format":"png",
    "resource_type":"image",
    "created_at":"dummy_data",
    "tags":["attachinary_tmp","development_env"],
    "bytes":0,
    "type":"upload",
    "etag":"dummy_etag",
    "url":"http://dummy.png",
    "secure_url":"http://dummy.png"}]'
  }

  let(:market_params) { { user_id: user.to_param, 
                  :market => market.attributes } }

  describe "Creating a new market" do

    it "assigns a new market" do
      get :new, {user_id: user.to_param}, valid_session
      expect(assigns(:market)).to be_a_new(Market)
    end

    describe "with valid parameters" do

      it "creates a new Market" do
        expect {
          post :create, market_params, valid_session
          }.to change(Market, :count).by(1)
      end

      it "redirects to the created market" do
        post :create, market_params, valid_session
        created_market_path = market_path Market.last
        expect(response).to redirect_to created_market_path
      end
    end
        
    describe "with invalid params" do

      before(:each) do
        Market.any_instance.stub(:save!).and_raise(MarketsDomainException)
      end

      it "re-renders the 'new' template" do
        post :create, market_params, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "Markets actions" do
    before :each do
      user = create(:user)
      sign_in :user, user
      category = create(:category)
      @market = create(:market, user: user, category: category)  
    end

    let(:market_params) { { id: @market.to_param, 
                          user_id: @market.user.id } }
    let(:market_update_params) { {
      id: @market.to_param,
      user_id: @market.user.id, 
      market: @market.attributes } } 

    it "deletes the market" do
      expect {
        delete :destroy, market_params , valid_session
        }.to change(Market, :count).by(-1)
    end

    it "redirects to the index template" do
      delete :destroy, market_params, valid_session
      response.should redirect_to user_markets_path(@market.user)
    end

    it "changes the name of the market" do
      @market.attributes["name"] = "New dummy name"
      put :update, market_update_params, valid_session
      @market.reload
      expect(@market.name).to eq("New dummy name") 
    end

    describe "update photo" do
      it "allows no photo" do
        put :update, market_update_params, valid_session
        expect(@market.featured).to be_nil
      end

      it "saves a valid featured photo" do
        @market.stub(:featured).and_return(photo_json)
        put :update, market_update_params, valid_session
        expect(@market.featured).not_to be_nil
      end
    end
  end

  describe "index" do
    it "renders the index template" do
      get :index, { user_id: user.to_param }, valid_session
      expect(response).to render_template("index")
    end

    it "lists user markets" do
      market = create(:market)
      market.update_attribute(:name, "dummy")
      get :index, {user_id: market.user_id}, valid_session
      markets = assigns(:markets)
      expect(markets.count).to eq 1
    end
  end

  describe "search" do
    it "renders the index template" do
      get :search, {}, valid_session
      expect(response).to render_template("index")
    end
  
    it "returns success with valid empty params" do
      params = {:query =>"", :category =>{:category_id =>""}, 
                    :range=>"today", :location=>{:location_id=>""}, 
                    :from => "", :to=>""}
      get :search, params, valid_session
      expect(response.response_code).to eq 200
    end

    it "returns success with valid half search params" do
      params = {:query =>"", :category =>{:category_id =>""}, 
                    :range=>"today", :location=>{:location_id=>""}, 
                    :from => "01/01/2014", :to=>""}
      get :search, params, valid_session
      expect(response.response_code).to eq 200
    end

    it "returns success with valid range params" do
      params = {:query =>"", :category =>{:category_id =>""}, 
                    :range=>"today", :location=>{:location_id=>""}, 
                    :from => "01/01/2014", :to=>"12/01/2014"}
      get :search, params, valid_session
      expect(response.response_code).to eq 200
    end
    it "returns success with valid full params" do
      SpecialLocation.create(name: "Malasaña", latitude: 40, longitude: -3)
      Category.create(name: "dummy")
      params = {:query =>"my search", :category =>{:category_id =>"dummy"}, 
                    :range=>"today", :location=>{:location_id=>"Malasaña"}, 
                    :from => "01/01/2014", :to=>"12/01/2014"}
      SpecialLocation.count.should eq 1
      get :search, params, valid_session
      expect(response.response_code).to eq 200
    end
  end

  describe "Permissions" do

    context "archive market" do
      before :each do
        @market = create(:market, :state => "published")
      end

      it "allowed for admin" do
        admin = create(:user, :admin)
        sign_in :user, admin

        post :archive, { market_id: @market.id }, valid_session
        expect(response.response_code).to eq 302
      end

      it "not allowed for regular user" do
        user = create(:user)
        sign_in :user, user

        post :archive, { market_id: @market.id }, valid_session
        expect(response.response_code).to eq 401
      end
    end
    
    context "delete picture" do

      before :each do
        @market = create(:market)
        @market.featured = photo_json
      end

      it "allowed for admin" do
        admin = create(:user, :admin)
        sign_in :user, admin

        post :delete_image, { market_id: @market.id }, valid_session
        expect(response.response_code).to eq 302
      end

      it "not allowed for regular user" do
        user = create(:user)
        sign_in :user, user

        post :delete_image, { market_id: @market.id }, valid_session
        expect(response.response_code).to eq 401
      end
    end

    context "update market" do

      let (:market_update_params) {
        {
          id: @market.to_param,
          user_id: @market.user.id, 
          market: @market.attributes
        }
      }

      before :each do
        @market = create(:market, :user => user)
        @market.featured = photo_json
      end

      it "allowed for admin" do
        admin = create(:user, :admin)
        sign_in :user, admin

        @market.attributes["name"] = "New dummy name"

        put :update, market_update_params, valid_session
        @market.reload
        expect(@market.name).to eq("New dummy name") 
      end

      it "not allowed for non owner" do
        other_user = create(:user)
        sign_in :user, other_user

        @market.attributes["name"] = "New dummy name"

        put :update, market_update_params, valid_session
        expect(response.response_code).to eq 401
      end
    end
  end
end