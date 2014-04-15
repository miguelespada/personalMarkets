When(/^I create a market$/) do
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

Then(/^I see my personal market page with the new data$/) do
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

Then(/^I should see it in my markets$/) do
  click_on "User"
  click_on "My markets"

  expect(page).to have_content "Dummy Market"
end

Then(/^I am notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
end

Given(/^I have some markets$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc"
    )
  @user.markets << @market
  @market = create(
    :market, :user => @user, 
    :name => "market 2", 
    :description => "market 2 desc")
  @user.markets << @market
end

When(/^I go to my markets list$/) do
  click_on "User"
  click_on "My markets"
end

Then(/^I see their names and descriptions$/) do
  expect(page).to have_content "market 1"
  expect(page).to have_content "market 1 desc"
  expect(page).to have_content "market 2"
  expect(page).to have_content "market 2 desc"
end

Then(/^I see an edit button$/) do
  all('.market-gallery-item').each do |item|
    expect(item).to have_link "Edit"
  end
end

Then(/^I see a delete button$/) do
  all('.market-gallery-item').each do |item|
    expect(item).to have_link "Delete"
  end
end

Then(/^I see a show button$/) do
  all('.market-gallery-item').each do |item|
    expect(item).to have_link "Show"
  end
end