When(/^I go to maps$/) do
  visit maps_path
end

Then(/^I should see a map$/) do
  page.should have_css('div#map')
  page.should have_css('.leaflet-tile-loaded')
end

Given(/^There is a market with latitude and longitude$/) do
  @market = FactoryGirl.create(:market, 
      :latitude => "40", :longitude=> "-3.7")
end

Then(/^I should see a marker on the map$/) do
  page.should have_css('.leaflet-marker-pane')
end

When(/^I click on the marker$/) do
  within(:css, ".leaflet-marker-pane") do
    find('img').click
  end
end

Then(/^I should see the market tooltip$/) do
  page.should have_content @market.name
  page.should have_content @market.description
end