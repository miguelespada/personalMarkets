Then(/^I should see a smallmap$/) do
  page.should have_css('div#map-small')
  page.should have_css('.leaflet-tile-loaded')
end
