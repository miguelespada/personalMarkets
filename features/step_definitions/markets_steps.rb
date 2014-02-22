Given(/^I am in the add market page$/) do
  visit '/markets/new'
end

When(/^I fill in the name and description$/) do
  fill_in "market-name",  with: "Dummy market"
  fill_in "market-description",  with: "Dummy description"
end

When(/^I click on the save market button$/) do
  click_on "Añadir market"
end

Then(/^I should see my personal market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
end
