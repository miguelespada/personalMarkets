Given(/^I go to Search$/) do
  visit search_path
end

When(/^I search with empty fields$/) do
  within(:css, "#search_market") do
    click_on "Search"
  end
end

Then(/^I should see all the markets$/) do
  expect(page).to have_content @market_0.name
  expect(page).to have_content @market_1.name
  expect(page).to have_content @market_2.name
  expect(page).to have_content @market_3.name
  expect(page).to have_content @market_4.name
  expect(page).to have_content @market_5.name
end

When(/^I search with a query$/) do
  fill_in "query",  with: "one"
  within(:css, "#search_market") do
    click_on "Search"
  end
end

Then(/^I should see the markets that match my search$/) do
  expect(page).to have_content @market_0.name
  expect(page).to have_content @market_1.name
  expect(page).not_to have_content @market_2.name
  expect(page).not_to have_content @market_3.name
  expect(page).not_to have_content @market_4.name
  expect(page).to have_content @market_5.name
end


When(/^I filter my search$/) do
  select @category.name
  step "I search with a query"
end

Then(/^I should see the markets that match my filtered search$/) do
  expect(page).to have_content @market_0.name
  expect(page).not_to have_content @market_1.name
  expect(page).not_to have_content @market_2.name
  expect(page).not_to have_content @market_3.name
  expect(page).not_to have_content @market_4.name
  expect(page).not_to have_content @market_5.name
end

When(/^I search with a date range$/) do
  fill_in "from",  with: "16/05/2014"
  fill_in "to",  with: "20/07/2014"
  step "I search with empty fields"
end

Then(/^I should see the markets that match my search with date$/) do
  expect(page).not_to have_content @market_0.name
  expect(page).not_to have_content @market_1.name
  expect(page).to have_content @market_2.name
  expect(page).not_to have_content @market_3.name
  expect(page).not_to have_content @market_4.name
  expect(page).not_to have_content @market_5.name
end
