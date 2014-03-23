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

Then(/^I should see a marker on the map$/) do
  page.should have_css('div#map')
  page.should have_css('.leaflet-tile-loaded')  
  page.should have_css('.leaflet-marker-pane')
end

Then(/^The market has tooltip$/) do
  within(:css, ".leaflet-marker-pane") do
    find('img').click
  end
  page.should have_content @market_0.name
  page.should have_content @market_0.description
end

Then(/^I should see the markets in the calendar$/) do
  within(:css, "#calendar") do
    expect(page).not_to have_content @market_0.name
    expect(page).to have_content @market_1.name
    expect(page).to have_content @market_2.name
    expect(page).to have_content @market_3.name
    expect(page).not_to have_content @market_4.name
    expect(page).not_to have_content @market_5.name

    expect(page).to have_content @market_1.date
    expect(page).to have_content @market_2.date
    expect(page).to have_content @market_3.date
  end
end
