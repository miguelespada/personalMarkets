Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end

Then(/^I should be notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
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