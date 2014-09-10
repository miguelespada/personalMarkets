When(/^I visit the sign in page$/) do
  visit new_user_session_path
end

Then(/^I am able to sign up with Gmail$/) do
  expect(page).to have_css ".Google"
end


Then(/^I am able to sign up with Facebook$/) do
  expect(page).to have_css ".Facebook"
end


Then(/^I should see the full description of the market including the address$/) do
  expect(page).to have_css '.market-location'
end

Given(/^I have a market$/) do
  @market = create(:market, :user => @user)
  @market.publish
  @user.markets << @market
end

When(/^I try to create another market$/) do
  visit new_user_market_path(@user)
end

Then(/^I should not be able to create another market this month$/) do
  step "I try to create another market"
  expect(page).to have_content "You have to wait"
end

Given(/^I have one month old market$/) do
  @market = create(:market, :user => @user)
  @market.created_at = 1.month.ago
  @user.markets << @market
end

Then(/^I can create a new market$/) do
  step "I try to create another market"
  expect(page).to have_css '#new_market'
end

Then(/^I should not be able to delete the featured image$/) do
  within(:css, '.market-featured-photo') do
    expect(page).to_not have_link "Delete"
  end
end

Given(/^I have an unpublished market$/) do
  @market = create(:market, :user => @user)
  @user.markets << @market
end

Then(/^I publish the draft$/) do
  @user.markets.first.publish
end

Given(/^I have four unpublished markets$/) do
  4.times do
    step "I have an unpublished market"
  end
end

Then(/^I publish all my drafts$/) do
  @user.markets.each do |m|
    m.publish
  end
end