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

Then(/^I see the markets matching my query$/) do
  page.should have_content @market_0.name
  page.should have_content @market_0.description
end

When(/^I select one category$/) do  
  within(:css, "#category_#{@category.id}") do
    click_on "Show"
  end
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
  page.should have_css(".calendar") 
end

Then(/^I should see all the markets$/) do
  page.should have_content @market_0.name
  page.should have_content @market_0.description
end

When(/^I do a search$/) do
  fill_in "query",  with: "market"
  fill_in "from",  with: "21/04/2015"
  fill_in "to",  with: "23/04/2015"
  click_button "Search"
end


When(/^I select range$/) do
  select "All", :from => "range"
end

When(/^I select incorrect range$/) do
  select "Today", :from => "range"
end

Then(/^I should not see the markets$/) do
  page.should_not have_content @market_0.name
  page.should_not have_content @market_0.description
end
