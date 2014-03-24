require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) } 
  let(:market) { FactoryGirl.build(:market)}
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


      it "assigns a newly created market" do
        post :create, market_params, valid_session
        expect(assigns(:market)).to be_a(Market)
        expect(assigns(:market)).to be_persisted
      end

      it "creates a new Market" do
        expect {
          post :create, market_params, valid_session
          }.to change(Market, :count).by(1)
      end

      it "redirects to the created market" do
        post :create, market_params, valid_session
        created_market_path = user_market_path(user, Market.last)
        expect(response).to redirect_to(created_market_path)
      end
    end
        
    describe "with invalid params" do

      before(:each) do
        Market.any_instance.stub(:save).and_return(false)
      end

      it "assigns a newly created but unsaved market" do
        post :create, market_params, valid_session
        expect(assigns(:market)).to be_a_new(Market)
      end

      it "re-renders the 'new' template" do
        post :create, market_params, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "Markets actions" do
    before :each do
      user = FactoryGirl.create(:user)
      category = FactoryGirl.create(:category)
      @market = FactoryGirl.create(:market, user: user, category: category)  
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
      m = FactoryGirl.create(:market)
      m.update_attribute(:name, "dummy")
      get :index, {user_id: m.user_id}, valid_session
      markets = assigns(:markets)
      expect(markets.count).to eq 1
    end
  end

  describe "search" do
    it "renders the index template" do
      get :search, {}, valid_session
      expect(response).to render_template("index")
    end
  end
end