When(/^I create a coupon$/) do
  click_on "Create Coupon"
  fill_in "Description",  with: "My dummy coupon"
  fill_in "Price",  with: "10"
  fill_in "Available",  with: "20"
  click_on "Create Coupon"
end

Then(/^I should see the coupon status page$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content "My dummy coupon"
  expect(page).to have_content "10"
  expect(page).to have_content "20"
end

When(/^I buy some coupons$/) do
  click_on "Buy Coupon"
  select "2"
  click_on "Buy"
end
