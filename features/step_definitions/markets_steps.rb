Given(/^I am in the add market page$/) do
  visit '/markets/new'
end

When(/^I fill in the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
end

When(/^I click on the save market button$/) do
  click_on "Create Market"
end

Then(/^I should see my personal market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end

Given(/^I am in the home page$/) do
	visit '/'
end

When(/^I click on the add market link$/) do
  click_on "Add market"
end

Then(/^I should see the creation market page$/) do
	expect(page).to have_content "Create new market"
end

Given(/^I am editing a market$/) do
	market = FactoryGirl.create(:market)
	visit market_path(market)
end

When(/^I upload a photo$/) do
	expect(page).to have_content "Add featured photo"
end
When(/^I click on update market$/) do
  click_on "Update Market"
end


Then(/^I should see the photo$/) do
	page.should have_selector "div.featured-photo"
end
