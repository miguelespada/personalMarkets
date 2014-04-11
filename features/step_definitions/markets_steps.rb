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

When(/^I edit my market$/) do
  visit market_path @market
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

When(/^I delete my market$/) do
  visit market_path @market
  within(:css, '.market-actions') do
    click_on "Delete"
  end
end

Then(/^I should not see the market in my markets list$/) do
  visit user_markets_path(@user)
  expect(page).not_to have_content @market.name
  expect(page).not_to have_content @market.description
end

Then(/^I should see the market in my markets list$/) do
  visit user_markets_path(@user)
  expect(page).to have_content @market.name
  expect(page).to have_content @market.description
end