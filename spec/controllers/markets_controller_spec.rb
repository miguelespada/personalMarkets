require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:market) { FactoryGirl.create(:market) } 
  let(:market_params) { FactoryGirl.attributes_for(:market) } 

  describe "Creating a new market" do
    it "assigns a new market" do
      get :new, {}, valid_session
      expect(assigns(:market)).to be_a_new(Market)
    end

      context "with valid params" do
        it "creates a new Market" do
          expect {
            post :create, { :market => market_params }, valid_session
          }.to change(Market, :count).by(1)
        end

        it "assigns a newly created market" do
          post :create, {:market => { name: "A name", description: "A description" } }, valid_session
          expect(assigns(:market)).to be_a(Market)
          expect(assigns(:market)).to be_persisted
        end

        it "redirects to the created market" do
          post :create, { :market => { 
            name: "A name", 
            description: "A description" } }, valid_session
          expect(response).to redirect_to(Market.last)
        end
      end

      describe "with invalid params" do
        before(:each) do
          Market.any_instance.stub(:save).and_return(false)
        end
        it "assigns a newly created but unsaved market" do
          post :create, {:market => { "name" => "invalid value" }}, valid_session
          expect(assigns(:market)).to be_a_new(Market)
        end

        it "re-renders the 'new' template" do
          post :create, {:market => { "name" => "invalid value" }}, valid_session
          expect(response).to render_template("new")
        end
      end
    end


      describe "updload foto" do
        it "uploads a valid featured photo" do
          market.stub(:featured).and_return('[{"public_id":"dummy",
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
            "secure_url":"http://dummy.png"}]')

          put :update, {id: market.to_param, market: market.attributes}, valid_session
          expect(market.featured).not_to be_nil
        end
    
        it "uploads an empty featured photo" do
          put :update, {id: market.to_param, market: market.attributes}, valid_session          
          expect(market.featured).to be_nil
        end
    end

end