When(/^I go to Markets$/) do
  visit published_markets_path
end

Given(/^I go to Tag list$/) do
    visit tags_path
end

Given(/^I go to Search$/) do
  visit "/markets/search"
end

Given(/^I go to Users$/) do
  visit users_path
end

Given(/^I go to Category list$/) do
  visit categories_path
end

When(/^I go to Map$/) do
  visit map_path
end

When(/^I go to Calendar$/) do
  visit calendar_path
end

When(/^I visit the edit market page$/) do
  visit edit_user_market_path(@user, @market)
end

When(/^I visit the market page$/) do
  visit market_path @market
end

Given(/^I go to Coupons$/) do
  visit coupons_path 
end

When(/^I go to SpecialLocations list$/) do
  visit special_locations_path 
end

When(/^I go to my wishlist$/) do
  visit user_wishes_path(@user)
end

Then(/^I go to wishlist$/) do
  visit wishes_gallery_path
end

When(/^I go to my bargain list$/) do
  visit user_bargains_path(@user)
end

Then(/^I go to bargain list$/) do
  visit bargains_path
end
When(/^I visit the markets page$/) do
  visit markets_path # express the regexp above with the code you wish you had
end

When(/^I visit a market$/) do
  user = create(:user)
  market = create(:market, user: user)
  visit market_path market
end
