When(/^I add a market$/) do
  click_on "User"
  click_on "Add market"

  within(:css, "#new_market") do
    fill_in "Name",  with: "Dummy Market"
    fill_in "Description",  with: "Dummy description"
    click_on "Create Market"
  end
end

Then(/^I should see the market page$/) do
  within(:css, ".market-full-description") do
    expect(page).to have_content "Dummy Market"
    expect(page).to have_content "Dummy description"
    expect(page).to have_content @user.email
    expect(page).to have_content "Uncategorized"
  end 
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end

When(/^I edit my market$/) do
  visit user_market_path(@user, @market)
  click_on "Edit"
  fill_in "Name",  with: "New dummy Market"
  fill_in "Description",  with: "New dummy description"
  click_on "Update Market"
end

Then(/^I should see my personal market page with the new data$/) do
  within(:css, ".market-full-description") do
    expect(page).to have_content "New dummy Market"
    expect(page).to have_content "New dummy description"
  end 
end

Then(/^I should be notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
end

When(/^I delete my market$/) do
  visit user_market_path(@user, @market)
  click_on "Delete"
end

Then(/^I should not see the market in my markets list$/) do
  visit user_markets_path(@user)
  expect(page).not_to have_content @market.name
  expect(page).not_to have_content @market.description
end

Then(/^I should be notified that the market has been succesfully deleted$/) do
  expect(page).to have_content "Market successfully deleted."
end

Then(/^I should see the market in my markets list$/) do
  visit user_markets_path(@user)
  expect(page).to have_content @market.name
  expect(page).to have_content @market.description
end




