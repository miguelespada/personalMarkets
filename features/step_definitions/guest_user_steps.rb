Given(/^I am not logged in$/) do

end

When(/^I visit a market page$/) do
  visit user_market_path @some_market.user, @some_market
end

Then(/^I should see the full description of the market except the address$/) do
  expect(page).to_not have_css '.market-location'
end