require 'spec_helper'

describe Market do

  it { should have_field :name }
  it { should have_field :description }

  describe "Search with no index" do
    it "creates an new index" do
      Market.delete_index
      expect{Market.search("", "")}.to change{Market.exists_index?}.from(false).to(true)
    end
  end 

  context "With no markets" do   
    describe "search" do
      it "returns an empty array" do
        Market.destroy_all
        expect(Market.search("", "")).to eq []
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
                         :date => "04/01/2014,06/01/2014,08/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 1", 
                                  :city => 'Barcelona',
                                  :date => "10/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 2", 
                                  :city => 'Madrid',
                                  :date => "15/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 3",
                                  :date => "19/01/2014")
      Market.refresh_index
    end   

    describe "search with blank query" do
      it "returns all the markets" do
        result = Market.search("")
        expect(result.count).to eq Market.all.count
      end
    end

    describe "full query"
      it "searches with specific name" do
        result = Market.search("Specific")
        expect(result.count).to eq 1
      end
      
      it "searches with generic name" do
        result = Market.search("Generic")
        expect(result.count).to eq Market.all.count - 1
      end

      it "searches with more generic name" do
        result = Market.search("market", "")
        expect(result.count).to eq Market.all.count
      end

      it "filters by category" do
        result = Market.search("market", @category.name)
        expect(result.count).to eq 1
      end


      describe "filter by city" do 
        it "filters by city" do
          result = Market.search("market", "", "", "", "Madrid")
          expect(result.count).to eq 2
        end

        it "filters by city with no city" do
          result = Market.search("market", "", "", "", "")
          expect(result.count).to eq 4
        end
      end 

      it "filters by date range, with only 'to'" do
        result = Market.search("market", "", "10/01/2014")
        expect(result.count).to eq 3
      end

      it "filters by date range" do
        result = Market.search("market", "", "11/01/2014", "16/01/2014" )
        expect(result.count).to eq 1
      end

      describe "a market has different dates" do
        it "filters by date range when multiple dates match 1" do
          result = Market.search("market", "", "04/01/2014", "04/01/2014" )
          expect(result.count).to eq 1
        end

        it "filters by date range when multiple dates  match 2" do
          result = Market.search("market", "", "06/01/2014", "06/01/2014" )
          expect(result.count).to eq 1
        end

        it "filters by date range when multiple dates  match 3" do
          result = Market.search("market", "", "08/01/2014", "08/01/2014" )
          expect(result.count).to eq 1
        end

        it "filters by date range when multiple dates match 4" do
          result = Market.search("market", "", "03/01/2014", "08/01/2014" )
          expect(result.count).to eq 1
        end
      end

      it "filters by date and category" do
        result = Market.search("market", @category.name, "08/01/2014", "20/01/2014" )
        expect(result.count).to eq 1
      end

      it "search by tag" do
        result = Market.search("tag_one", "" )
        expect(result.count).to eq 1
      end

      it "filters out wrong formatted dates" do
        result = Market.search("market", "", "xxx")
        expect(result.count).to eq Market.all.count
      end

      it "splits the date" do
        expect(@market.format_date.count).to eq 3 
      end

    it "filters out short queries"
    
    describe "filtering by location distance" do
        it "filters by location distance" do
          result = Market.search("market", "", "", "", "", 40, -70)
          expect(result.count).to eq 1
        end
        
        it "combines two filters" do
          result = Market.search("market", "Dummy", "", "", "", 40, -70)
          expect(result.count).to eq 0
        end

        it "filters out by location distance" do
          result = Market.search("market", "", "", "", "", 100, 100)
          expect(result.count).to eq 0
        end
    end
  end
end