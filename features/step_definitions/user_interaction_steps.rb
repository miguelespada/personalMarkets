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

Then(/^I should see the full description of the market including the address$/) do
  expect(page).to have_css '.market-location'
end

Given(/^I create a market$/) do
  @market = create(:market, :user => @user)
  @user.markets << @market
end

When(/^I try to create another market$/) do
  visit new_user_market_path(@user)
end

Then(/^I can see an error message$/) do
  expect(page).to_not have_css '#new_market'
  expect(page).to have_content "You have to wait one month to create another market"
end

Given(/^I have one month old market$/) do
  @market = create(:market, :user => @user)
  @market.created_at = 1.month.ago
  @user.markets << @market
end

Then(/^I can see the new market form$/) do
  expect(page).to have_css '#new_market'
end

Then(/^I should not be able to delete the featured image$/) do
  within(:css, '.market-featured-photo') do
    expect(page).to_not have_link "Delete"
  end
end