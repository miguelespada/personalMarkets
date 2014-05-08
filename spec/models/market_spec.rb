require 'spec_helper'

describe Market do

  it { should have_field :name }
  it { should have_field :description }

  describe "Search with no index" do
    it "creates an new index" do
      Market.delete_index
      expect{Market.search({})}.to change{Market.exists_index?}.from(false).to(true)
    end
  end 

  context "With no markets" do   
    describe "search" do
      it "returns an empty array" do
        Market.destroy_all
        expect(Market.search({})).to eq []
      end
    end
  end
  
  context "With markets" do 
    before :each do
      Market.delete_all
      @category =  FactoryGirl.create(:category, :name => "category") 
      @market = FactoryGirl.create(:market, 
                         :name => "Specific", 
                         :description => "Specific market", 
                         :tags => "tag one, tag two, tag three",
                         :city => "Madrid",
                         :category => @category,
                         :latitude => 40.0001,
                         :longitude => -70.002,
                         :state => 'published',
                         :date => "04/01/2014,06/01/2014,08/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 1", 
                                  :city => 'Barcelona',
                                  :description => "The awesome ultraspefic",
                                  :state => 'published',
                                  :date => "10/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 2", 
                                  :city => 'Madrid',
                                  :state => 'published',
                                  :date => "15/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 3",
                                  :state => 'published',
                                  :date => "19/01/2014")
      FactoryGirl.create(:market, :name => "market unpublished",
                                  :date => "19/01/2014")
      Market.refresh_index
    end   

    describe "search with blank query" do
      it "returns all the markets" do
        params = {}
        result = Market.search(params)
        expect(result.count).to eq Market.where(state: "published").count
      end
    end

    describe "query" do
      it "searches with specific name" do
        params = {:query  => "specific"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "queries are additive AND" do
        params = {:query  => "specific market"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "queries do not allow all symbols" do
        params = {:query  => "specific market!!!"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end
      
      it "searches with generic name" do
        params = {:query  => "generic"}
        result = Market.search(params)
        expect(result.count).to eq Market.where(state: "published").count - 1
      end

      it "searches with more generic name" do
        params = {:query  => "market"}
        result = Market.search(params)
        expect(result.count).to eq Market.where(state: "published").count
      end
        it "search by tag" do
        params = {:query  => "tag one"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "search by other tag" do
        params = {:query  => "tag three"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "search in description" do
        params = {:query  => "awesome"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end

    end 

    describe "filter" do
      it "by category" do
        params = { :category => @category.name}
        result = Market.search(params)
        expect(result.count).to eq 1
      end
      it "by city" do
        params = {
          :query => "market",
          :city => "Madrid"
        }
        result = Market.search(params)
        expect(result.count).to eq 2
      end

      it "filters by date range" do
        params = {
          :from => "11/01/2014",
          :to => "16/01/2014"
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "filters by date range, with only 'from'" do
        params = {
          :query => "market",
          :from => "10/01/2014"
        }
        result = Market.search(params)
        expect(result.count).to eq 3
      end
    end 

    describe "filters by location" do
      it "by location distance" do
        params = {
          :query => "market",
          :latitude => "40",
          :longitude => "-70"
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "combines location with category" do
        params = {
          :query => "market",
          :latitude => "40",
          :longitude => "-70",
          :category => "dummy"
        }
        result = Market.search(params)
        expect(result.count).to eq 0
      end

      it "filters out by location distance" do
        params = {
          :latitude => "100",
          :longitude => "100"
        }
        result = Market.search(params)
        expect(result.count).to eq 0
      end
    end

    describe "Markets with different dates" do
      it "splits the date" do
        expect(@market.format_date.count).to eq 3 
      end

      it "filters by date range when multiple dates match 1" do
        params = {
          :from => "04/01/2014",
          :to => "04/01/2014"
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "filters by date range when multiple dates  match 2" do
        params = {
          :from => "6/01/2014",
          :to => "06/01/2014"
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "filters by date range when multiple dates  match 3" do
        params = {
          :from => "08/01/2014",
          :to => "08/01/2014"
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "filters by date range when multiple dates match 4" do
        params = {
          :from => "03/01/2014",
          :to => "08/01/2014"
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end
      it "filters by date and category" do
        params = {
          :from => "08/01/2014",
          :to => "20/01/2014",
          :category => @category.name
        }
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "filters out wrong formatted dates" do
        params = {
          :from => "08/01/20x4"
        }
        result = Market.search(params)
        expect(result.count).to eq Market.where(state: "published").count
      end
    end

  end
  describe "sort results" do
    before :each do
      Market.delete_all
      FactoryGirl.create(:market,:name => "Market 3", 
                                  :state => 'published',
                                  :date => "15/01/2014")
      FactoryGirl.create(:market, :name => "Market 1", 
                                  :state => 'published',
                                  :date => "10/01/2014")
      FactoryGirl.create(:market, :name => "Market 2", 
                                  :state => 'published',
                                  :date => "12/01/2014")
      Market.refresh_index
    end   
    
    it "sorts queries" do
      result = Market.search({})
      expect(result.count).to eq 3
      expect(result.first.name).to eq "Market 1"
      expect(result.last.name).to eq "Market 3"
    end
  end

  describe "#coupon available" do

    context 'without coupon' do

      it "is not available" do
        market = create(:market)
        expect(market.coupon_available?).to be_false
      end

    end

    context 'with coupon' do

      it "is not available if regular user and market not pro" do
        market = create(:market, :user => create(:user), :coupon => create(:coupon))
        expect(market.coupon_available?).to be_false
      end
      
      it "is available if regular user and market pro" do
        market = create(:market, :user => create(:user), :coupon => create(:coupon), :pro => true)
        expect(market.coupon_available?).to be_true
      end
      
      it "is available if premium user" do
        market = create(:market, :user => create(:user, :premium), :coupon => create(:coupon), :pro => false)
        expect(market.coupon_available?).to be_true
      end
      
    end

  end
end