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

  describe "list" do
   it "renders the index template" do
      get :index, {user_id: user.to_param}, valid_session
      expect(response).to render_template("index")
    end
  end

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
      describe "search model" do

        it "searches with no query" do
          pending("Return correct markets")
        end

        it "searches with no query" do
          pending("Should give all models")
        end

        xit "searches with no markets" do
          pending("Should not give and error because there is no index")
        end

        xit "searches with no user" do
          pending("Should search in all markets")
        end

        xit "searches with user" do
          pending("Should search in user markets")
        end
      end
  end 

  describe "Elastic search" do
      it 'creates and destroys index' do
        FactoryGirl.create(:market)
        Market.es.index.refresh
        Market.es.index.exists?.should be_true
        Market.es_index_name.should eq 'markets'
        Market.es.index.delete
        Market.es.index.exists?.should be_false
      end
      context 'search' do
        before :each do
          Market.es.index.delete
          @m1 = FactoryGirl.create(:market)
          @m2 = FactoryGirl.create(:market)
          @m3 = FactoryGirl.create(:market)
          @m1.update_attribute(:name, "Test")
          Market.es.index.refresh
        end 
        it 'searches all models' do
            results = Market.es.search q: 'Market'
            results.count.should eq 3
            results.to_a.count.should eq 3
        end
        it 'searches one model' do
            results = Market.es.search q: @m1.name
            results.count.should eq 1
            results.to_a.count.should eq 1
            results.first.id.should eq @m1.id
            results.first.user_id.should eq @m1.user_id
        end
      end
      context 'destroy' do
        before :each do
           @markets = []
           10.times { @markets << FactoryGirl.create(:market)}
           Market.es.index.refresh
        end
        it 'destroy' do
          Market.es.all.count.should eq 10
          @markets[0].destroy
          Market.es.index.refresh
          Market.es.all.count.should eq 9
        end
        it 'destroy all' do
          Market.es.all.count.should eq 10
          Market.destroy_all
          Market.es.index.refresh
          Market.es.all.count.should eq 0
        end
      end
  end

end