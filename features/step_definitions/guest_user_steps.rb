Given(/^I am not logged in$/) do

end

When(/^I visit a market page$/) do
  visit user_market_path @some_market.user, @some_market
end

Then(/^I should see the full description of the market except the address$/) do
  expect(page).to_not have_css '.market-location'
end


When(/^I visit the sign in page$/) do
  visit new_user_session_path
end

Then(/^I am able to sign up with Facebook and Gmail$/) do
  expect(page).to have_link "Facebook"
  expect(page).to have_link "Google"
end

