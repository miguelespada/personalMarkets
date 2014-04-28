When(/^I create a coupon$/) do
  within(:css, "#form-market-coupon") do
    fill_in "Description",  with: "My dummy coupon"
    fill_in "Price",  with: "10"
    fill_in "Available",  with: "20"
  end 
  click_on "Update Market"
end

When(/^I should see the coupon in the market page$/) do
  step "I visit the market page"
  expect(page).to have_content @market.name
  expect(page).to have_content "My dummy coupon"
  expect(page).to have_content "10"
  expect(page).to have_content "20"
end

Given(/^I buy some coupons$/) do
  step "I visit the market page"
  click_on "Buy Coupon"
  select "2"
  click_on "Buy"
end

Then(/^I should see the coupon transactions in my out transactions$/) do
  click_on "Coupon transactions"
  within(:css, ".out_coupons") do
    expect(page).to have_content "Dummy coupon"
  end 
end

Then(/^I sign in as the market owner$/) do  
  step "I sign out"
  log_in_as @market_owner
end

Then(/^I should see the coupon transactions in my in transactions$/) do
  click_on "Coupon transactions"
  within(:css, ".in_coupons") do
    expect(page).to have_content "Dummy coupon"
  end 
end

When(/^All the coupons are sold$/) do
  @market.coupon.available = 0
  @market.coupon.save
end

When(/^I try to buy the coupon$/) do
  step "I visit the market page"
  click_on "Buy Coupon"
end

When(/^I should see that the coupon sold out$/) do
  expect(page).to have_content "Sold out"
end

Then(/^I should see all the coupons that are emitted$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content @market.user.email
  expect(page).to have_content @coupon.description
end