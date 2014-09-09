Then(/^I should see that I am logged$/) do
  expect(page).to have_content "dummy@gmail.com"
end

Then(/^I should not see that I am logged$/) do
  expect(page).not_to have_content "dummy@gmail.com"
end

Then(/^I should be notified that the market has been added$/) do
  expect(find('#notice')).to have_content "Your market was created successfully"
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
  expect(page).to have_content "Your category was created successfully"
end

Then(/^I should be notified that the category has been deleted$/) do
  expect(page).to have_content "Your category was deleted successfully"
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
  expect(whatever).to have_content "The coupon is bought successfully"
end


Then(/^I should be notified that I cannot delete the category$/) do
  expect(page).to have_content "Your category cannot be deleted"
end

Then(/^I should be notified that I the category has been updated$/) do
  expect(page).to have_content 'Your category was updated successfully'
end

Then(/^I should be notified that the tag has been added$/) do
  expect(page).to have_content "Your tag was created successfully"
end

Then(/^I should be notified that the tag has been deleted$/) do
  expect(page).to have_content "Your tag was deleted successfully"
end

Then(/^I should be notified that I the tag has been updated$/) do
  expect(page).to have_content 'Your tag was updated successfully'
end

Then(/^I should be notified that the special_location has been added$/) do
  expect(page).to have_content "Your hotspot was created successfully"
end


Then(/^I should be notified that the special_location has been deleted$/) do
  expect(page).to have_content "Your hotspot was deleted successfully"
end

Then(/^I should be notified that the special_location has been updated$/) do
  expect(page).to have_content "Your hotspot was updated successfully"
end

Then(/^I should be notified that the wish has been added$/) do
  expect(page).to have_content "Your wish was created successfully"
end

Then(/^I should be notified that the wish has been deleted$/) do
  expect(page).to have_content "Your wish was deleted successfully"
end

Then(/^I should be notified that the wish has been updated$/) do
  expect(page).to have_content "Your wish was updated successfully"
end

Then(/^I should be notified that the bargain has been added$/) do
  expect(page).to have_content "Your bargain was created successfully"
end

Then(/^I should be notified that the bargain has been deleted$/) do
  expect(page).to have_content "Your bargain was deleted successfully"
end

Then(/^I should be notified that the bargain has been updated$/) do
  expect(page).to have_content "Your bargain was updated successfully"
end

