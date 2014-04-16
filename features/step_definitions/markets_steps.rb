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

Then(/^I can edit the market$/) do
  within(:css, ".market-actions") do
    expect(page).to have_link "Edit"
  end
end

When(/^I edit the market$/) do
  step "I change market info"
end

When(/^I edit my market$/) do
  visit market_path @market
  step "I change market info"
end

When(/^I change market info$/) do
  within(:css, ".market-actions") do
    click_on "Edit"
  end
  fill_in "Name",  with: "New dummy Market"
  fill_in "Description",  with: "New dummy description"
  click_on "Update Market"
end


Then(/^I see the market page with the new data$/) do
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

Given(/^I have some published markets$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => :published
    )
  @user.markets << @market
  @market = create(
    :market, :user => @user, 
    :name => "market 2", 
    :description => "market 2 desc",
    :state => :published)
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

When(/^I am in the market page$/) do
  visit market_path @some_market
end

Then(/^there is a like button$/) do
  within(:css, '.market-actions') do
    expect(page).to have_link 'Like'
  end
end

Then(/^there is no like button$/) do
  within(:css, '.market-actions') do
    expect(page).to_not have_link 'Like'
  end
end

When(/^click the like button$/) do
  within(:css, '.market-actions') do
    click_on "Like"
  end
end

Then(/^the number of likes increment$/) do
  within(:css, '.market-likes-number') do
    expect(page).to have_content "1"
  end
end

Then(/^I cannot like that market again$/) do
  visit market_path @some_market
  step "there is no like button"
end

Given(/^I liked a market$/) do
  step "There is someone else's market"
  step "I am logged in"
  step "I am in the market page"
  step "click the like button"
  step "I am in the market page"
end

Then(/^there is an unlike button$/) do
  within(:css, '.market-actions') do
    expect(page).to have_link 'Unlike'
  end
end

When(/^I click the unlike button$/) do
  within(:css, '.market-actions') do
    click_on "Unlike"
  end
  visit market_path @some_market
end

Then(/^the number of likes decrement$/) do
  within(:css, '.market-likes-number') do
    expect(page).to have_content "0"
  end
end

Given(/^I am not logged in$/) do

end

When(/^I visit a market page$/) do
  visit market_path @some_market
end

Then(/^I should see the full description of the market except the address$/) do
  expect(page).to_not have_css '.market-location'
end

Then(/^It is not visible in guest markets$/) do
  visit published_markets_path
  within(:css, '.market-gallery') do
    expect(page).to_not have_css '.market-gallery-item'
  end
end

Then(/^I have a draft market$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc"
    )
  @user.markets << @market
end

When(/^I go the market page$/) do
  visit market_path @market
end

Then(/^I can publish it$/) do
  within(:css, '.market-actions') do
    expect(page).to have_link "Publish"
  end
end

When(/^I publish the market$/) do
  click_on "Publish"
end

Then(/^I see a success publishing notification$/) do
  expect(page).to have_content "Market successfully published."
end

Then(/^I see it in the published markets$/) do
  visit published_markets_path
  within(:css, '.market-gallery') do
    expect(page).to have_content @market.name
  end
end

Then(/^I cannot publish it again$/) do
  within(:css, '.market-actions') do
    expect(page).to_not have_link "Publish"
  end
end

When(/^I archive the market$/) do
  click_on "Archive"
end

When(/^I visit a published market$/) do
  market = create(
    :market, 
    :user => create(:user), 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => "published"
    )
  visit market_path market
end