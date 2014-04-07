Given(/^There are some categories$/) do
  @category = create(:category,
              :name => "Dummy Category")
end

Given(/^There are some markets$/) do
  step "There are some categories"
  @market_0 = create(:market, 
      :latitude => "40", 
      :longitude=> "-3.7",
      :tags => "one",
      :category => @category,
      :date=>"22/03/2014")
  Market.reindex
end

Given(/^I have one market$/) do
  @market = create(:market, :user => @user)
  @user.markets << @market
end

Given(/^There is someone else's market$/) do
  user = create(:user)
  @some_market = create(:market, :user => user)
end

Given(/^there are some users$/) do
  @user_0 = create(:user)
  @user_1 = create(:user)
end

Given(/^There is a comment in a market$/) do
  @other_user = create(:user)
  @market = create(:market, :user => @other_user)
  @other_user.markets << @market
  @comment = create(:comment, :market => @market)
  @market.comments << @comment
end