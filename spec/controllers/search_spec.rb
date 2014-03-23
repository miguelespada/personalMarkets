require 'spec_helper'

describe MarketsController do

  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) } 
  let(:market) { FactoryGirl.build(:market)}

  describe "creating an index" do
    it "creates index" do
      Market.delete_index
      Market.destroy_all
      get :search, {}, valid_session
      expect(Market.exists_index?).to eq true
    end
  end
  describe "search markets" do
    before :each do
      Market.reindex
    end
    it "renders the index template" do
      get :search, {}, valid_session
      expect(response).to render_template("index")
    end
    context "with no markets and no index" do
      it "it does no show any market" do
        Market.destroy_all
        get :search, {}, valid_session
        markets = assigns(:markets)
        expect(markets.count).to eq 0
      end
    end
    
    context 'with markets' do
      before :each do
         Market.destroy_all
         Market.create_index
         @markets = []
         10.times { @markets << FactoryGirl.create(:market)}
         Market.refresh_index
      end

      describe "searches with no query" do
        it "returns all the markets" do
          get :search, {}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq Market.all.count
        end
      end

      describe "searches with blank query" do
        it "returns all the markets" do
          get :search, {query: ""}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq Market.all.count
        end
      end

      describe "searches with query" do
        it "return the matching markets" do
          FactoryGirl.create(:market, :name => "dummy")
          Market.refresh_index
          get :search, {query: "market"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq (Market.all.count - 1)
        end

        it "returns the exact mathc" do
          market = FactoryGirl.create(:market, :name => "dummy")
          Market.refresh_index
          get :search, {query: market.name}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 1
        end

        it "can be filtered with blank category" do
          get :search, { category: "" }, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq Market.all.count
        end

        it "can filtered with a specific category" do
          get :search, 
            { category: { "category_id" => @markets.first.category.name } }, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 1
        end

        it "can be filtered any category" do
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

      describe 'search by date range' do
        before :each do
          Market.destroy_all
          Market.create_index
          FactoryGirl.create(:market, date: "10/01/2014")
          FactoryGirl.create(:market, date: "12/01/2014")
          Market.refresh_index
        end
        it "returns the markets inside the range" do
          get :search, {from: "09/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 2
        end

        it "retuns only the markets inside the range" do
          get :search, {from: "11/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 1
        end

        it "does not return the markets outside the range" do
          get :search, {from: "14/01/2014", to: "17/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 0
        end
      end

      describe 'search by date and category' do
        before :each do
          Market.destroy_all
          Market.create_index
          @market = FactoryGirl.create(:market, date: "08/01/2014",)
          FactoryGirl.create(:market, date: "12/01/2014")
          Market.refresh_index
        end

        it "matches the range and filters by category" do
          get :search, {category: { "category_id" => @market.category.name }, 
                        from: "07/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 1
        end

        it "filters out by category " do
          get :search, {category: { "category_id" => "wrong" }, 
                        from: "07/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 0
        end
      end
      
      describe 'search by date and query' do
        before :each do
          Market.destroy_all
          Market.create_index
          FactoryGirl.create(:market, name: "dummy market", date: "08/01/2014",)
          FactoryGirl.create(:market, name: "foo market", date: "12/01/2014")
          Market.refresh_index
        end

        it "matches the query inside the date range" do
          get :search, {query: "dummy", 
                        from: "07/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 1
        end

        it "matches the tag inside the date range" do
          get :search, {query: "market", 
                        from: "07/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 2
        end

        it "does not match markets" do
          get :search, {query: "wrong", 
                        from: "07/01/2014", to: "13/01/2014"}, valid_session
          markets = assigns(:markets)
          expect(markets.count).to eq 0
        end
      end
    end

  end 
  describe 'fail tolerante search' do
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