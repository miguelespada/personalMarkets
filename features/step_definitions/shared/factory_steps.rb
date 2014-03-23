Given(/^There are some indexed markets$/) do
  @category = FactoryGirl.create(:category)
  @market_0 = FactoryGirl.create(:market, 
              :name => "Market one", 
              :category => @category, 
              :tags => "one, two, three")
  @market_1 = FactoryGirl.create(:market, 
              :name => "Supermarket one", 
              :date => "13/05/2014", 
              :tags => "one, three")
  @market_2 = FactoryGirl.create(:market, 
              :name => "Market two", 
              :date => "17/07/2014", 
              :tags => "two, three")
  @market_3 = FactoryGirl.create(:market, 
              :name => "Market three", 
              :date => "20/09/2014")
  @market_4 = FactoryGirl.create(:market, 
              :description => "Description three")
  @market_5 = FactoryGirl.create(:market, 
              :description => "Description one")
  Market.reindex
end