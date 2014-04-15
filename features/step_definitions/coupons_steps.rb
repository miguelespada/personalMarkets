When(/^I buy some coupons$/) do
  step "I visit the market page"
  click_on "Buy Coupon"
  select "2"
  click_on "Buy"
end

Then(/^I should see the coupon status page$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content "My dummy coupon"
  expect(page).to have_content "10"
  expect(page).to have_content "20"
end

Then(/^I should see the coupons in My Coupons$/) do
  within(:css, ".user-links") do
    click_on "My coupons"
  end
  expect(page).to have_content "Dummy coupon"
end


When(/^I create a coupon with no available items$/) do
  click_on "Create Coupon"
  fill_in "Description",  with: "My dummy coupon"
  fill_in "Price",  with: "10"
  fill_in "Available",  with: "0"
  click_on "Create Coupon"
end

When(/^I try to buy the coupon$/) do
  step "I visit the market page"
  click_on "Buy Coupon"
end

When(/^I should see that the coupon sold out$/) do
  expect(page).to have_content "Sold out"
end

Given(/^there are some coupons$/) do
  step "I am logged in"
  step "I have one market"
  step "I visit the market page"
  step "I create a coupon"
  step "I sign out"
end

When(/^I create a coupon$/) do
  click_on "Create Coupon"
  fill_in "Description",  with: "My dummy coupon"
  fill_in "Price",  with: "10"
  fill_in "Available",  with: "20"
  click_on "Create Coupon"
end

Given(/^I go to Coupons$/) do
  within(:css, ".admin-links") do
    click_on "Coupons"
  end
end

Then(/^I should see all the coupons that are emitted$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content @market.user.email
  expect(page).to have_content @coupon.description
end

Then(/^The market owner should see that I bought some coupons$/) do
  step "Log in as market owner"
  step "Visit coupon transactions"
  step "See the coupon that has been sold"
end

Then(/^Log in as market owner$/) do
  log_in_as @market_owner
end

Then(/^Visit coupon transactions$/) do
  within(:css, ".user-links") do
    click_on "Coupons transactions"
  end
end

Then(/^The admin should see that I bought some coupons$/) do
  step "I am logged in as an admin"
  step "I go to Coupons"
  step "See the coupon that has been sold"
end

Then(/^See the coupon that has been sold$/) do
  expect(page).to have_content @user.email
  expect(page).to have_content @market.name
  expect(page).to have_content @market.user.email
  expect(page).to have_content @coupon.description
  expect(page).to have_content "2"
end

