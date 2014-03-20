Then(/^I should see a smallmap$/) do
  page.should have_css('div#map-small')
  page.should have_css('.leaflet-tile-loaded')
end

Then(/^I click on the smallmap$/) do
  within(:css, "div#map-small") do
    first('img').click
  end
end

Given(/^I have filled the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
end