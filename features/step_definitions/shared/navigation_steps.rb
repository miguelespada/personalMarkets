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
