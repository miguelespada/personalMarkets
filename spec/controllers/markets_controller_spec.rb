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

    context "with valid parameters" do

      let(:market_params) { { user_id: user.to_param, :market => market.attributes } }

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
    end

    describe "Removing or modifying a market" do

      before :each do
        user = FactoryGirl.create(:user)
        category = FactoryGirl.create(:category)
        @market = FactoryGirl.create(:market, user: user, category: category)  
      end

      let(:market_params) { { id: @market.to_param, user_id: @market.user.id } }
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

          describe "upload foto" do

            it "update with no photo" do
              put :update, market_update_params, valid_session
              expect(@market.featured).to be_nil
            end

            it "uploads a valid featured photo" do
              @market.stub(:featured).and_return(photo_json)
              put :update, market_update_params, valid_session
              expect(@market.featured).not_to be_nil
            end
          end

          describe "list" do
           it "renders the index template" do
            get :index, { user_id: user.to_param }, valid_session
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
            expect(markets.count).to eq Market.all.count
          end

          it "searches with blank query" do
            get :search, {query: ""}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq Market.all.count
          end

          it "searches with generic name" do
            FactoryGirl.create(:market, :name => "dummy")
            Market.refresh_index
            get :search, {query: "market"}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq (Market.all.count - 1)
          end

          it "searches with query" do
            market = FactoryGirl.create(:market, :name => "dummy")
            Market.refresh_index
            get :search, {query: market.name}, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 1
          end

          it "filter with blank category" do
            get :search, { category: "" }, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq Market.all.count
          end

          it "filter match category" do
            get :search, { category: { "category_id" => @markets.first.category.name } }, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 1
          end

          it "filter do not match any category" do
            get :search, { category: { "category_id" => "wrong" } }, valid_session
            markets = assigns(:markets)
            expect(markets.count).to eq 0
          end

          it "search and filter" do
            market = FactoryGirl.create(:market)
            Market.refresh_index
            get :search, {
              query: "market",
              category: { "category_id" => market.category.name}}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 1
            end

            it "remembers category after search" do
              get :search, {}, valid_session
              category_query = assigns(:category_query)
              expect(category_query).not_to be_nil
            end
          
          end
          context 'search by date' do
            before :each do
              Market.destroy_all
              Market.create_index
              FactoryGirl.create(:market, date: "10/01/2014")
              FactoryGirl.create(:market, date: "12/01/2014")
              Market.refresh_index
            end
            it "they match inside the a range" do
              get :search, {from: "09/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 2
            end

            it "some match inside the a range" do
              get :search, {from: "11/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 1
            end

            it "they do no match outside range" do
              get :search, {from: "14/01/2014", to: "17/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 0
            end
          end
          context 'search by date and category' do
            before :each do
              Market.destroy_all
              Market.create_index
              @market = FactoryGirl.create(:market, date: "08/01/2014",)
              FactoryGirl.create(:market, date: "12/01/2014")
              Market.refresh_index
            end
            it "they match inside the a range filtered by category " do
              get :search, {category: { "category_id" => @market.category.name }, 
                            from: "07/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 1
            end

            it "they do not match inside the a range with wrong category " do
              get :search, {category: { "category_id" => "wrong" }, 
                            from: "07/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 0
            end
          end
          context 'search by date and query' do
            before :each do
              Market.destroy_all
              Market.create_index
              FactoryGirl.create(:market, name: "dummy market", date: "08/01/2014",)
              FactoryGirl.create(:market, name: "foo market", date: "12/01/2014")
              Market.refresh_index
            end
            it "they match inside the a range with tag " do
              get :search, {query: "dummy", 
                            from: "07/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 1
            end

            it "they match inside the a range with tag " do
              get :search, {query: "market", 
                            from: "07/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 2
            end

            it "they do not match inside the a range with tag " do
              get :search, {query: "wrong", 
                            from: "07/01/2014", to: "13/01/2014"}, valid_session
              markets = assigns(:markets)
              expect(markets.count).to eq 0
            end
          end
          context 'fail tolerante search' do
            before :each do
              Market.destroy_all
              Market.create_index
              FactoryGirl.create(:market, name: "dummy market", date: "08/01/2014",)
              FactoryGirl.create(:market, name: "foo market", date: "12/01/2014")
              Market.refresh_index
            end
            it "respons successfull with wrong date formats " do
              get :search, {from: "07/xx/2014", to: "13/01/2014"}, valid_session
              response.should be_success
              markets = assigns(:markets)
              expect(markets.count).to eq 2
            end

            it "respons successfull with only one date param" do
              get :search, {from: "11/01/2014"}, valid_session
              response.should be_success
              markets = assigns(:markets)
              expect(markets.count).to eq 1
            end
          end
      end
    end
  end