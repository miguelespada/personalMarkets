Then(/^I should see that I am logged$/) do
  expect(page).to have_content "dummy@gmail.com"
end

Then(/^I should not see that I am logged$/) do
  expect(page).not_to have_content "dummy@gmail.com"
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end

Then(/^I should be notified that the market has been succesfully deleted$/) do
  expect(page).to have_content "Market successfully deleted."
end

Then(/^I should be notified that I have registered succesfully$/) do
  expect(page).to have_content "You have signed up successfully"
end

Then(/^I should be notified that the I signned in$/) do
  expect(page).to have_content "Signed in successfully."
end

Then(/^I should be notified that the I signned out$/) do
  expect(page).to have_content "Signed out successfully."
end

Then(/^I should be notified that the category has been added$/) do
  expect(page).to have_content "Category was successfully created."
end

Then(/^I should be notified that the category has been deleted$/) do
  expect(page).to have_content "Category successfully deleted."
end

Then(/^I should be notified that the coupon has been created$/) do
  expect(page).to have_content "Coupon was successfully created."
end

Then(/^I should be notified that the coupons has been bought$/) do
  begin
    whatever = find("#notice")
  rescue Exception => e
    p "trying to find it hidden"
    whatever ||= find("#notice", :visible => false)
  end
  expect(whatever).to have_content "You has successfully bought the coupon."
end


Then(/^I should be notified that I cannot delete the category$/) do
  expect(page).to have_content "Cannot delete category."
end

Then(/^I should be notified that I the category has been updated$/) do
  expect(page).to have_content 'Category was successfully updated.'
end

Then(/^I should be notified that the tag has been added$/) do
  expect(page).to have_content "Tag was successfully created."
end

Then(/^I should be notified that the tag has been deleted$/) do
  expect(page).to have_content "Tag successfully deleted."
end

Then(/^I should be notified that I the tag has been updated$/) do
  expect(page).to have_content 'Tag was successfully updated.'
end

Then(/^I should be notified that the special_location has been added$/) do
  expect(page).to have_content "Special location was successfully created."
end


Then(/^I should be notified that the special_location has been deleted$/) do
  expect(page).to have_content "Special location successfully deleted."
end

Then(/^I should be notified that the special_location has been updated$/) do
  expect(page).to have_content "Special location was successfully updated."
end

Then(/^I should be notified that the wish has been added$/) do
  expect(page).to have_content "Wish was successfully created."
end

Then(/^I should be notified that the wish has been deleted$/) do
  expect(page).to have_content "Wish successfully deleted."
end

Then(/^I should be notified that the wish has been updated$/) do
  expect(page).to have_content "Wish was successfully updated."
end

Then(/^I should be notified that the bargain has been added$/) do
  expect(page).to have_content "Bargain was successfully created."
end

Then(/^I should be notified that the bargain has been deleted$/) do
  expect(page).to have_content "Bargain successfully deleted."
end

Then(/^I should be notified that the bargain has been updated$/) do
  expect(page).to have_content "Bargain was successfully updated."
end

