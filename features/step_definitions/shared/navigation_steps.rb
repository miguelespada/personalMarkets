When(/^I go to Markets$/) do
  visit published_markets_path
end

Given(/^I go to Tag list$/) do
    visit tags_path
end

Given(/^I go to Search$/) do
  visit search_path
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