Given(/^There are some categories$/) do
  @category = create(:category,
              :name => "Dummy_Category")
  @category_1 = create(:category,
              :name => "Filter")
end


When(/^There are some special locations$/) do
  @location_0 = create(:special_location,
                    :name => "hotspot_0",
                    :latitude => "40.1", 
                    :longitude=> "-3.73")
  @location_1 = create(:special_location,
                    :name => "hotspot_1",
                    :latitude => "43.1", 
                    :longitude=> "-4.69")
end

When(/^There is a category with markets$/) do
  step "There are some published markets"
end

Given(/^There are some published markets$/) do
  step "There are some categories"
  @market_0 = create(:market, 
      :latitude => "40", 
      :longitude=> "-3.7",
      :tags => "tag_one",
      :category => @category,
      :date=> Time.now.next_month.strftime("%d/%m/%Y"),
      :state => :published)
  @market_1 = create(:market, 
      :latitude => "43", 
      :longitude=> "-4.7",
      :tags => "tag_two",
      :category => @category_1,
      :date => Time.now.strftime("%d/%m/%Y"),
      :state => :published)
  Market.reindex
end

Given(/^I have one market$/) do
  @market = create(:market, :user => @user, :coupon => Coupon.new)
  @user.markets << @market
end

Given(/^I have one pro market$/) do
  @market = create(:market, :user => @user, :coupon => Coupon.new, :pro => true)
  @user.markets << @market
end

Given(/^there are some users$/) do
  @user_0 = create(:user)
  @user_1 = create(:user)
  @users = [@user_0, @user_1]
end


Given(/^There is a market with available coupons$/) do
  @market_owner = create(:user)
  @coupon = create(:coupon)
  @market = create(:market, :user => @market_owner, :coupon => @coupon, :pro => true)
  @coupon.market = @market
  @coupon.save
end

Given(/^There is someone else's market$/) do
  @market = create(:market, 
      :latitude => "40", 
      :longitude=> "-3.7")
end

Given(/^There are some tags/) do
  @tag = create(:tag,
              :name => "Dummy Tag")
end

When(/^There is a market with a specific tag$/) do
  step "There are some tags"
  @market = create(:market, :tags => @tag.name)
end

When(/^There are some special_locations$/) do
  @location = create(:special_location,
              :name => "Dummy Location")
end

When(/^There are some wishes$/) do
  @wish = create(:wish,
              :description => "Dummy Wish", :user => @user)
end

When(/^There are some bargains$/) do
  @bargain = create(:bargain,
              :description => "Dummy Bargain", :user => @user)
end


Given(/^I have a market with photo$/) do
  step "I am logged in"
  @photo = create(:photo)
  @market = create(:market, :user => @user, :featured => @photo)
  @photo.photographic = @market
  @photo.save

  @user.markets << @market
end


