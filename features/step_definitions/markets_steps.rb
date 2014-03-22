Given(/^I am logged in$/) do
  step "I am a registerd user"
  step "I sign in"
end

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
