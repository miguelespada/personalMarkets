Given(/^There is a user with some coupons sold$/) do
  @owner = create(:user)
  earning_1 = create(:earning, :amount => 10.5, :user => @owner)
  earning_2 = create(:earning, :amount => 4.10, :user => @owner)
end

When(/^I pay him back$/) do
  admin = create(:user, :admin)
  log_in_as admin
  visit new_user_payback_path(@owner)
  fill_in "Payback amount", :with => 7.4
  click_on "Pay"
end

Then(/^the money owed to him decreases$/) do
  visit user_accounting_path(@owner)
  expect(find("#owed")).to have_content("7.2")
  expect(find("#paybacks")).to have_content("7.4")
end

