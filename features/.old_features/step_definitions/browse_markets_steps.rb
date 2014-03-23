Given(/^There are some indexed markets$/) do
  @market_0 = FactoryGirl.create(:market, :name => "Market one")
  FactoryGirl.create(:market, :name => "Market two")
  Market.reindex
end

When(/^I go to the Markets$/) do  visit "/"
  click_on "Markets"
end

When(/^I go to Search$/) do  visit "/"
  visit search_path
end

Then(/^I should see all the markets$/) do
  expect(page).to have_content "Market one"
  expect(page).to have_content "Market two"
end

When(/^I fill the search field$/) do
  fill_in "query",  with: "one"
end

When(/^I click search$/) do
  click_button "Search" 
end

Then(/^I should see the markets that match my search$/) do
  expect(page).to have_content "Market one"
  expect(page).not_to have_content "Market two"
end

When(/^I click the details link of a market$/) do
  within("//div[@id='market_#{@market_0.id}']") do
    click_on "Show"
  end
end

Then(/^I should see the full description of a market$/) do
  expect(page).to have_content @market_0.name
  expect(page).to have_content @market_0.description
  expect(page).to have_content @market_0.category.name
  expect(page).to have_content @market_0.user.email
end

Given(/^I am a signed in$/) do
  @user = FactoryGirl.create(:user)

  click_link "Sign in"
  fill_in "Email",  with: @user.email
  fill_in "Password",  with: "password", :match => :prefer_exact
  click_button "Sign in"

  FactoryGirl.create(:market, :name => "My market one", :user => @user)
  FactoryGirl.create(:market, :name => "My market two", :user => @user)
end

Given(/^I go to my markets$/) do
  visit user_markets_path(@user)
end

Then(/^I should see all my markets$/) do
  expect(page).to have_content "My market one"
  expect(page).to have_content "My market two"
end

Then(/^I should see only my markets$/) do
  expect(page).not_to have_content "Market one"
  expect(page).not_to have_content "Market two"
end

When(/^I select one category$/) do
  select @market_0.category.name
end

Then(/^I should see the markets that match my category$/) do
  expect(page).to have_content "Market one"
  expect(page).not_to have_content "Market two"
end