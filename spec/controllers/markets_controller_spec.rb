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

  

  describe "Creating a new market" do
    it "assigns a new market" do
      get :new, {user_id: user.to_param}, valid_session
      expect(assigns(:market)).to be_a_new(Market)
    end

    context "with valid params" do
        it "creates a new Market" do
          expect {
            post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          }.to change(Market, :count).by(1)
        end
    
        it "assigns a newly created market" do
          post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          expect(assigns(:market)).to be_a(Market)
          expect(assigns(:market)).to be_persisted
        end

        it "redirects to the created market" do
          post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
          expect(response).to redirect_to(user_market_path(user,Market.last))
        end
        describe "with invalid params" do
          before(:each) do
            Market.any_instance.stub(:save).and_return(false)
          end
          it "assigns a newly created but unsaved market" do
            post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
            expect(assigns(:market)).to be_a_new(Market)
          end
           it "re-renders the 'new' template" do
              post :create, {user_id: user.to_param, :market => market.attributes }, valid_session
              expect(response).to render_template("new")
          end
      end
    end
  end
  describe "removes or modifies market" do
      before :each do
         @market = FactoryGirl.create(:market, 
              :user => FactoryGirl.create(:user),
              :category => FactoryGirl.create(:category))  
      end

      it "deletes market" do
          expect {
            delete :destroy, { id: @market.to_param, user_id: @market.user.id }, valid_session
          }.to change(Market, :count).by(-1)
      end
      it "redirects to user#index" do
          delete :destroy, { id: @market.to_param, user_id: @market.user.id }, valid_session
         response.should redirect_to user_markets_path(@market.user)
      end

      it "change name" do
        @market.attributes["name"] = "New dummy name"
        put :update, { id: @market.to_param, user_id: @market.user.id, 
            :market => @market.attributes}, valid_session
        @market.reload
        expect(@market.name).to eq("New dummy name") 
      end
      
      describe "upload foto" do
      
       it "update with no photo" do
          put :update, { id: @market.to_param, user_id: @market.user.id, 
              :market => @market.attributes}, valid_session
          expect(@market.featured).to be_nil
        end

        it "uploads a valid featured photo" do
            @market.stub(:featured).and_return(photo_json)
            put :update, { id: @market.to_param, user_id: @market.user.id, 
                :market => @market.attributes}, valid_session
            expect(@market.featured).not_to be_nil
        end
      end
      describe "list" do
       it "renders the index template" do
          get :index, {user_id: user.to_param}, valid_session
          expect(response).to render_template("index")
       end
       it "list user markets" do
         m = FactoryGirl.create(:market)
         m.update_attribute(:name, "dummy")
         get :index, {user_id: m.user_id}, valid_session
         markets = assigns(:markets)
         expect(markets.count).to eq 1
        end
      end


      describe "search model" do
        it "renders the index template" do
          get :search, {}, valid_session
          expect(response).to render_template("index")
        end

        it "creates index" do
            Market.delete_index
            get :search, {}, valid_session
            expect(Market.exists_index?).to eq true
        end
        
        it "searches with no markets and no index" do
          Market.destroy_all
          get :search, {}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 0
        end
        context 'with markets' do
          before :each do
             Market.destroy_all
             Market.create_index
             @markets = []
             10.times { @markets << FactoryGirl.create(:market)}
             Market.refresh_index
          end
          it "searches with no query" do
            get :search, {}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 10
          end
          it "searches with blank query" do
            get :search, {query: ""}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 10
          end

          it "searches with generic name" do
            m = FactoryGirl.create(:market, :name => "dummy")
            Market.refresh_index
            get :search, {query: "market"}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq (Market.all.count - 1)
          end

          it "searches with query" do
            m = FactoryGirl.create(:market, :name => "dummy")
            Market.refresh_index
            get :search, {query: m.name}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 1
          end

          it "filter with blank category" do
            get :search, {category: ""}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq Market.all.count
          end

          it "filter match category" do
            get :search, {category: {"category_id"=>@markets.first.category.name}}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 1
          end

          it "filter do not match any category" do
            get :search, {category: {"category_id"=>"wrong"}}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 0
          end

          it "search and filter" do
            m = FactoryGirl.create(:market)
            Market.refresh_index
            get :search, {query: "market", category: {"category_id"=>m.category.name}}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 1
          end

          it "remembers category after search" do
            get :search, {}, valid_session
            category_query = assigns(:category_query)
            expect(category_query).not_to be_nil
          end
        end
      end

  end
end