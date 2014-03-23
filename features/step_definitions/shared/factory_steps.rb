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
              :category => @category, 
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

Given(/^I have one market$/) do
  @market = FactoryGirl.create(:market, :user => @user)
  @user.markets << @market
end

Given(/^There is someone else's market$/) do
  user = FactoryGirl.create(:user)
  @some_market = FactoryGirl.create(:market, :user => user)
end

Given(/^there are some users$/) do
  @user_0 = FactoryGirl.create(:user)
  @user_1 = FactoryGirl.create(:user)
end

Given(/^There are some categories$/) do
  @category = FactoryGirl.create(:category,
              :name => "Dummy Category")
end
