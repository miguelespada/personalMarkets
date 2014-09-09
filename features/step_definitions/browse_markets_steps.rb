When(/^I click the details link of a market$/) do
  within(:css, "#market_#{@market_0.id}") do
    find(".show").click
  end
end

Then(/^I should see the full description of a market$/) do
  expect(page).to have_content @market_0.name
  expect(page).to have_content @market_0.description
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


Then(/^I should see the markets in the calendar$/) do
  page.should have_css(".calendar") 
end

Then(/^I should see all the markets$/) do
  page.should have_content @market_0.name
  page.should have_content @market_0.description
end

When(/^I do a search$/) do
  within(:css, ".search-form") do
    fill_in "query",  with: ""
  end
  find("#search_button").click
end


When(/^I select range$/) do
  select "Today", :from => "range"
end


When(/^I select a category filter$/) do
    click_on @market_1.category.name.downcase
end

When(/^I type a query$/) do
  fill_in "query",  with: "tag_two"
  page.execute_script("$('#query').trigger('change');")
end


Then(/^I should not see the markets$/) do
  page.should_not have_content @market_0.name
  page.should_not have_content @market_0.description
end

Then(/^I see the markets matching my filters$/) do
  page.should have_content @market_1.name
  page.should have_content @market_1.description
  page.should_not have_content @market_0.name
  page.should_not have_content @market_0.description
end

Then(/^I select range all$/) do
  select "All", :from => "range"
end

Then(/^I see all markets$/) do
  page.should have_content @market_1.name
  page.should have_content @market_1.description
  page.should have_content @market_0.name
  page.should have_content @market_0.description
end

When(/^I select a special location$/) do
  select "hotspot_1", :from => "location_location_id"
end

When(/^I select a city$/) do
  find("#city").select("madrid")
end

When(/^I allow geolocation$/) do
  page.execute_script('$("#user_lat").val("43");')
  page.execute_script('$("#user_lon").val("-4.71");')
  page.execute_script("$('#location_location_id').append(\"<option value='My location'>My location</option>\");")
end

When(/^I select search by my location$/) do
  find("#location_location_id").select("My location")
  page.execute_script("$('#query').trigger('change');")
end

