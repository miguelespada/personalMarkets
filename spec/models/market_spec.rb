require 'spec_helper'

describe Market do

  it { should have_field :name }
  it { should have_field :description }

   describe "Market state" do
     it "market has date" do
      day = Time.now.strftime("%d/%m/%Y")
      @market = create(:market,:schedule => day)
      expect(@market.has_date?).to eq true
    end

    it "market hasnot date" do
      @market = create(:market)
      expect(@market.has_date?).to eq false
    end


    it "today market has started" do
      day = Time.now.strftime("%d/%m/%Y")
      @market = create(:market,:schedule => day)
      expect(@market.started?).to eq true
      expect(@market.is_today?).to eq true
    end

    it "checks if it is published last month" do
      @market = create(:market)
      expect(@market.published_last_month?).to eq false
      @market.publish
      expect(@market.published_last_month?).to eq true
      @market.publish_date = 2.months.ago
      expect(@market.published_last_month?).to eq false
    end

    it "market is running" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 4.days.from_now.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market,:schedule => days)
      expect(@market.is_today?).to eq false
      expect(@market.running?).to eq true
    end

    it "market is not running" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day2
      @market = create(:market,:schedule => days)
      expect(@market.is_today?).to eq false
      expect(@market.running?).to eq false
      expect(@market.passed?).to eq true
    end

    it "market is running" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 1.day.from_now.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market,:schedule => days)
      expect(@market.in_date?(Date.tomorrow)).to eq true
      expect(@market.in_date?(Date.today)).to eq false
      expect(@market.in_date?(Date.today + 1.day)).to eq true
      expect(@market.in_date?(Date.today + 2.days)).to eq false
      expect(@market.in_date?(Date.today + 3.days)).to eq false
    end

    it "today market has not passed" do
      day1 = Date.today.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 1.day.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market,:schedule => days)
      expect(@market.passed?).to eq false
    end

    it "yesterday market has started" do
      day = 1.day.ago.strftime("%d/%m/%Y")
      @market = create(:market,:schedule => day)
      expect(@market.started?).to eq true
    end

    it "yesterday market has passed" do
      day = 1.day.ago.strftime("%d/%m/%Y")
      @market = create(:market,:schedule => day)
      expect(@market.passed?).to eq true
    end

    describe "several schedules" do
      it " market has started and passed" do
        day1 = 1.day.ago.strftime("%d/%m/%Y")
        day2 = 2.days.from_now.strftime("%d/%m/%Y")
        days = day1 + ";" + day2
        @market = create(:market,:schedule => days)
        expect(@market.passed?).to eq false
        expect(@market.started?).to eq true
        expect(@market.is_this_week?).to eq true
      end

      it "not yet started" do
        day1 = 2.days.from_now.strftime("%d/%m/%Y")
        day2 = 5.days.from_now.strftime("%d/%m/%Y")
        days = day1 + ";" + day2
        @market = create(:market,:schedule => days)
        expect(@market.passed?).to eq false
        expect(@market.started?).to eq false
      end
    end
    
    it "has been published" do
      @market = create(:market)
      expect(@market.has_been_published?).to eq false
      @market.publish
      expect(@market.has_been_published?).to eq true
      @market.unpublish
      expect(@market.has_been_published?).to eq true
    end
  end

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
        expect(Market.search({})[:markets]).to eq []
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
                         :schedule => "04/01/2014;06/01/2014;08/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 1", 
                                  :city => 'Barcelona',
                                  :description => "The awesome ultraspefic",
                                  :state => 'published',
                                  :schedule => "10/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 2", 
                                  :city => 'Madrid',
                                  :state => 'published',
                                  :schedule => "15/01/2014")
      FactoryGirl.create(:market, :name => "Generic market 3",
                                  :state => 'published',
                                  :schedule => "19/01/2014")
      FactoryGirl.create(:market, :name => "market unpublished",
                                  :schedule => "19/01/2014")
      Market.refresh_index
    end   

    describe "search with blank query" do
      it "returns all the markets" do
        params = {}
        result = Market.search(params)[:markets]
        expect(result.count).to eq Market.where(state: "published").count
      end
      it "paginates" do
        params = {}
        result = Market.search(params, 1, 2)[:markets]
        expect(result.count).to eq 2
      end

      it "paginates" do
        params = {}
        result = Market.search(params, 2, 2)[:markets]
        expect(result.count).to eq 2
      end
      
      it "paginates" do
        params = {}
        result = Market.search(params, 2, 3)[:markets]
        total = Market.search(params, 2, 3)[:total]
        expect(result.count).to eq 1
        expect(total).to eq 4
      end
    end

    describe "query" do
      it "searches with specific name" do
        params = {:query  => "specific"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "queries are additive AND" do
        params = {:query  => "specific market"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "queries do not allow all symbols" do
        params = {:query  => "specific market!!!"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end
      
      it "searches with generic name" do
        params = {:query  => "generic"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq Market.where(state: "published").count - 1
      end

      it "searches with more generic name" do
        params = {:query  => "market"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq Market.where(state: "published").count
      end
        it "search by tag" do
        params = {:query  => "tag one"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "search by other tag" do
        params = {:query  => "tag three"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "search in description" do
        params = {:query  => "awesome"}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

    end 

    describe "filter" do
      it "by category" do
        params = { :category => @category.name}
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end
      it "filters by date range" do
        params = {
          :from => "11/01/2014",
          :to => "16/01/2014"
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "filters by date range, with only 'from'" do
        params = {
          :query => "market",
          :from => "10/01/2014"
        }
        result = Market.search(params)[:markets]
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
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "combines location with category" do
        params = {
          :query => "market",
          :latitude => "40",
          :longitude => "-70",
          :category => "dummy"
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq 0
      end

      it "filters out by location distance" do
        params = {
          :latitude => "100",
          :longitude => "100"
        }
        result = Market.search(params)[:markets]
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
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "filters by date range when multiple dates  match 2" do
        params = {
          :from => "6/01/2014",
          :to => "06/01/2014"
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "filters by date range when multiple dates  match 3" do
        params = {
          :from => "08/01/2014",
          :to => "08/01/2014"
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "filters by date range when multiple dates match 4" do
        params = {
          :from => "03/01/2014",
          :to => "08/01/2014"
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end
      it "filters by date and category" do
        params = {
          :from => "08/01/2014",
          :to => "20/01/2014",
          :category => @category.name
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq 1
      end

      it "filters out wrong formatted dates" do
        params = {
          :from => "08/01/20x4"
        }
        result = Market.search(params)[:markets]
        expect(result.count).to eq Market.where(state: "published").count
      end
    end

  end
  describe "sort results" do
    before :each do
      Market.delete_all
      FactoryGirl.create(:market,:name => "Market 3", 
                                  :state => 'published',
                                  :schedule => "15/01/2014")
      FactoryGirl.create(:market, :name => "Market 1", 
                                  :state => 'published',
                                  :schedule => "10/01/2014")
      FactoryGirl.create(:market, :name => "Market 2", 
                                  :state => 'published',
                                  :schedule => "12/01/2014")
      Market.refresh_index
    end   
    
    it "sorts queries" do
      result = Market.search({})[:markets]
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

  describe "schedule" do
      
      it "returns the correct date" do
        @market = create(:market,:schedule => "12/01/2014,00:00,10:00")
        expect(@market.date).to eq "12/01/2014"
      end

      it "returns the correct date with several dates" do
        @market = create(:market,:schedule => "16/07/2014,10:00,20:00;17/07/2014,10:00,20:00")
        expect(@market.date).to eq "16/07/2014,17/07/2014"
      end
      
      it "allows incomplete schedules" do
        @market = create(:market,:schedule => "16/07/2014")
        expect(@market.date).to eq "16/07/2014"
      end
      it "allows incomplete schedules with several dates" do
        @market = create(:market,:schedule => "16/07/2014;17/07/2014")
        expect(@market.date).to eq "16/07/2014,17/07/2014"
      end
  end

  describe "dates utils" do

    it "sorts after save" do
      schedule = "17/07/2014;18/07/2014;16/07/2014"
      @market = create(:market,:schedule => schedule)
      expect(@market.schedule).to eq "16/07/2014,00:00,23:59;17/07/2014,00:00,23:59;18/07/2014,00:00,23:59"
    end

     it "sorts after update" do
      @market = create(:market)
      schedule = "17/07/2014;18/07/2014;16/07/2014"
      @market.update(:schedule => schedule)
      expect(@market.schedule).to eq "16/07/2014,00:00,23:59;17/07/2014,00:00,23:59;18/07/2014,00:00,23:59"
    end

    it "sorts after save with empty schedule" do
      @market = create(:market)
      expect(@market.schedule).to eq nil
    end

    it "returns first date" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 3.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market,:schedule => days)
      expect(@market.first_date.day).to eq 3.days.ago.day
    end

    it "returns last date" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 3.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market,:schedule => days)
      expect(@market.last_date.day).to eq 1.day.ago.day
    end

    it "can last 7 days for normal users" do
      @market = create(:market)
      expect(@market.max_duration).to eq 7
    end

    it "can last 30 days for premium users" do
      premium = create(:user, :premium)
      @market = create(:market, :user => premium)
      expect(@market.max_duration).to eq 30
    end

    it "dates within market duration" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 3.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market)
      expect(@market.within_duration?(days)).to eq true
    end

    it "dates within market duration empty dates" do
      @market = create(:market)
      expect(@market.within_duration?(@market.date)).to eq true
    end

    it "dates not within market duration" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 14.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      @market = create(:market)
      expect(@market.within_duration?(days)).to eq false
    end

  end

  describe "date evaluator" do
    it "allows validates good dates" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 5.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      market = create(:market)
      expect(DateEvaluator.new(market).validate_dates!(days)).to eq true
    end
    it "allows validates wrong dates" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 12.days.ago.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      market = create(:market)
      expect{ DateEvaluator.new(market).validate_dates!(days) }.to raise_error( MarketDateException )
    end

    it "does not allow to modify passed dates" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 5.days.ago.strftime("%d/%m/%Y")
      day4 = 3.days.from_now.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2
      new_days = day1 + ";" + day2 + ";" + day4
      market = create(:market,
                      :schedule => days)
      market.publish
      market.unpublish
      expect{ DateEvaluator.new(market).validate_dates!(new_days) }.to raise_error( MarketDateException )
    end

    it "it allows to modify today" do
      day1 = 0.day.from_now.strftime("%d/%m/%Y")
      day2 = 3.days.from_now.strftime("%d/%m/%Y")
      days = day1
      new_days = day2
      market = create(:market,
                      :schedule => days)
      market.publish
      expect( DateEvaluator.new(market).validate_dates!(new_days) ).to eq true
    end

    it "it does not allow to modify yesterday" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 3.days.from_now.strftime("%d/%m/%Y")
      days = day1
      new_days = day2
      market = create(:market,
                      :schedule => days)
      market.publish
      expect{ DateEvaluator.new(market).validate_dates!(new_days) }.to raise_error( MarketDateException )
    end

    it "it allows to modify not passed dates" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 3.days.ago.strftime("%d/%m/%Y")
      day4 = 1.day.from_now.strftime("%d/%m/%Y")
      day5 = 2.days.from_now.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2 + ";" + day4
      new_days = day1 + ";" + day2 + ";" + day3 + ";" + day5
      market = create(:market,
                      :schedule => days)
      market.publish
      expect( DateEvaluator.new(market).validate_dates!(new_days) ).to eq true
    end

    it "it allows to modify dates if market not published" do
      day1 = 1.day.ago.strftime("%d/%m/%Y")
      day2 = 2.days.ago.strftime("%d/%m/%Y")
      day3 = 3.days.ago.strftime("%d/%m/%Y")
      day4 = 2.days.from_now.strftime("%d/%m/%Y")
      days = day1 + ";" + day3 + ";" + day2 
      new_days = day3 + ";" + day4
      market = create(:market,
                      :schedule => days)
      expect( DateEvaluator.new(market).validate_dates!(new_days) ).to eq true
    end
  end

end