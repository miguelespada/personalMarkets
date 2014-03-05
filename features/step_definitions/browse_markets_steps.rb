
Given(/^There are some indexed markets$/) do
  Market.es.index.reset
  @market0 = FactoryGirl.create(:market, :name => "Market one")
  FactoryGirl.create(:market, :name => "Market two")
  Market.es.index.refresh
end

When(/^I go to the Markets$/) do  visit "/"
  click_on "Markets"
end


Then(/^I should see all the markets$/) do
  expect(page).to have_content "Market one"
  expect(page).to have_content "Market two"
end

When(/^I fill the search field$/) do
  fill_in "query",  with: "one"
end

When(/^I click search$/) do
  click_button "Search" 
end

Then(/^I should see the markets that match my search$/) do
  expect(page).to have_content "Market one"
  expect(page).not_to have_content "Market two"
end

When(/^I click the details link of a market$/) do
  within("//tr[@id='#{@market0.id}']") do
    click_on "Show"
  end
end

Then(/^I should see the full description of a market$/) do

  expect(page).to have_content @market0.name
  expect(page).to have_content @market0.description
  expect(page).to have_content @market0.category.name
  expect(page).to have_content @market0.user.email
end
