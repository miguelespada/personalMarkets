When(/^I add a special_location$/) do
  step "I go to SpecialLocations list"
  find('.new').click  
  fill_in "Name",  with: "Dummy Location"
  fill_in "City", with: "Madrid"
  fill_in "Latitude", with: "10"
  fill_in "Longitude", with: "10"
  click_on "Create"
end

Then(/^I should see the special_location in the special_location list$/) do
  step "I go to SpecialLocations list"
  expect(page).to have_content "Dummy Location"
end

When(/^I delete a special_location$/) do
  step "I go to SpecialLocations list"
  within(:css, "#special_location_#{@location.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the special_location in the special_location list$/) do
  step "I go to SpecialLocations list"
  expect(page).not_to have_content "Dummy Location"
end

When(/^I edit a special_location$/) do
  step "I go to SpecialLocations list"
  within(:css, "#special_location_#{@location.id}") do
    find('.edit').click  
  end
  fill_in "Name",  with: "New Dummy Location"
  click_on "Update"
end

Then(/^I should see the special_location with the new name in the special_location list$/) do
  step "I go to SpecialLocations list"
  expect(page).to have_content "New Dummy Location"
end

When(/^I browse the special_location$/) do
  step "I go to SpecialLocations list"
  within(:css, "#special_location_#{@location.id}") do
    click_on @location.name
  end
end

Then(/^I should see the markets special_location near the speacial location$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content @market.description
end

When(/^I add an important special_location$/) do
  step "I go to SpecialLocations list"
  find('.new').click  
  fill_in "Name",  with: "Dummy Location"
  fill_in "City", with: "Madrid"
  fill_in "Latitude", with: "10"
  fill_in "Longitude", with: "10"
  find_by_id("special_location_important").click
  find(:css, "#special_location_important").set(true)
  click_on "Create"
end

Then(/^I should see the special_location in the navigation bar$/) do
  visit special_locations_list_path
  expect(page).to have_content "Dummy Location"
end
