Then(/^I should see that I am logged$/) do
  expect(page).to have_content "You are logged as: dummy@gmail.com"
end

Then(/^I should not see that I am logged$/) do
  expect(page).not_to have_content "You are logged as: dummy@gmail.com"
end