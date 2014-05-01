Given(/^There are some categories$/) do
  @category = create(:category,
              :name => "Dummy Category")
end

When(/^There is a category with markets$/) do
  step "There are some published markets"
end

Given(/^There are some published markets$/) do
  step "There are some categories"
  @market_0 = create(:market, 
      :latitude => "40", 
      :longitude=> "-3.7",
      :tags => "one",
      :category => @category,
      :date=>"22/04/2015",
      :state => :published)
  Market.reindex
end

Given(/^I have one market$/) do
  @market = create(:market, :user => @user, :coupon => Coupon.new)
  @user.markets << @market
end

Given(/^There is someone else's market$/) do
  user = create(:user)
  @some_market = create(:market, :user => user)
end

Given(/^there are some users$/) do
  @user_0 = create(:user)
  @user_1 = create(:user)
  @users = [@user_0, @user_1]
end

Given(/^There is a comment in a market$/) do
  @other_user = create(:user)
  @market = create(:market, :user => @other_user)
  @other_user.markets << @market
  @comment = create(:comment, :market => @market)
  @market.comments << @comment
end

Given(/^There is a market with available coupons$/) do
  @market_owner = create(:user)
  @coupon = create(:coupon)
  @market = create(:market, :user => @market_owner, :coupon => @coupon)
  @coupon.market = @market
  @coupon.save
end
