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

Then(/^I click on create market$/) do
  click_button "Create Market"
end

Then(/^I should see the location$/) do
  sleep (1)
  within(:css, "div.market-latitude") do
    expect(page).to have_content "."
  end
  within(:css, "div.market-longitude") do
    expect(page).to have_content "."
  end
end

Then(/^I should see the address$/) do
  within(:css, "div.market-address") do
    has_text?
  end
end