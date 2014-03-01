Given(/^I am in the add market page$/) do
  @categories = FactoryGirl.create_list(:category, 5)
  visit '/markets/new'
end

When(/^I fill in the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
end

When(/^I fill the category$/) do
  select @categories.last.name
end

When(/^I click on the save market button$/) do
  click_on "Create Market"
end

Then(/^I should see my personal market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
  expect(page).to have_content  @categories.last.name
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end

Given(/^I go to the market manager page$/) do
  @markets = FactoryGirl.create_list(:market, 5)
  visit "/"
  click_on "Manage markets"
end

Given(/^There are some markets$/) do
end

Then(/^I should see the lists of markets$/) do
  @markets.each do |m|
    expect(page).to have_content m.name
  end
end

Given(/^There is a market$/) do
  @market = FactoryGirl.create(:market)
end

When(/^I click on a market$/) do
    visit market_path(@market) 
end

When(/^I click the edit button$/) do
  visit edit_market_path(@market) 
end

When(/^I fill the name with a new name$/) do
  fill_in "Name",  with: "New dummy Market"
end

When(/^I click on the update market button$/) do
  click_on "Update Market"
end

Then(/^I should see my personal market page with the new name$/) do
  expect(page).to have_content "New dummy Market"
end

Then(/^I should be notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
end

When(/^I click the delete button$/) do
    within(:xpath, "//tr[@id='"+@markets[0].id+"']") do
      click_on "Delete"
    end
end

Then(/^I should go to the market manager page$/) do
    expect(page).to have_content "Market list"
end
Then(/^I should not see the market$/) do
  expect(page).not_to have_xpath("//tr[@id='"+@markets[0].id+"']")
end



