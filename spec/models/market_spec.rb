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
                         :tags => "tag_one, tag_two, tag_three",
                         :city => "Madrid",
                         :category => @category,
                         :latitude => 40.001,
                         :longitude => -70.02,
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
        params = {:query  => "tag_one"}
        result = Market.search(params)
        expect(result.count).to eq 1
      end

      it "search by other tag" do
        params = {:query  => "tag_three"}
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
          :from => "08/01/20s4"
        }
        result = Market.search(params)
        expect(result.count).to eq Market.where(state: "published").count
      end
    end


    it "filters out short queries"
    it "boots matches on the name"

  end
end