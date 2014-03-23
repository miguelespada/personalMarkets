When(/^I click the details link of a market$/) do
  within(:css, "#market_#{@market_0.id}") do
    click_on "Show"
  end
end

Then(/^I should see the full description of a market$/) do
  within(:css, ".market-full-description") do
    expect(page).to have_content @market_0.name
    expect(page).to have_content @market_0.description
  end
end

Given(/^I select one tag$/) do
  click_on "one"
end

Then(/^I see the markets matching the tag$/) do
  expect(page).to have_content @market_0.name
  expect(page).to have_content @market_1.name
  expect(page).not_to have_content @market_2.name
  expect(page).not_to have_content @market_3.name
  expect(page).not_to have_content @market_4.name
  expect(page).to have_content @market_5.name
end

When(/^I select one category$/) do  
  within(:css, "#category_#{@category.id}") do
    click_on "Show"
  end
end

Then(/^I see the markets matching the category$/) do
  expect(page).to have_content @market_0.name
  expect(page).not_to have_content @market_1.name
  expect(page).to have_content @market_2.name
  expect(page).not_to have_content @market_3.name
  expect(page).not_to have_content @market_4.name
  expect(page).not_to have_content @market_5.name
end
