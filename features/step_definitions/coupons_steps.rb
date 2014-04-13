When(/^I create a coupon$/) do
  click_on "Create Coupon"
  fill_in "Description",  with: "My dummy coupon"
  fill_in "Price",  with: "10"
  click_on "Create Coupon"
end

Then(/^I should see the coupon status page$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content "My dummy coupon"
end
