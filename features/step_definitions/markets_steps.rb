# Given(/^I am in my user space$/) do
#   @user = FactoryGirl.create(:user)
#   @category = FactoryGirl.create(:category)
#   visit user_path(@user)
# end

When(/^I click on add market$/) do
  click_on "Add market"
end

Given(/^There is one category$/) do
  @category = FactoryGirl.create(:category)
end


When(/^I fill in the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
  select(@category.name, :from => 'Category')
end

When(/^I click on the save market button$/) do
  click_button "Create Market"
end

Then(/^I should see the market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
  expect(page).to have_content @user.email
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end

When(/^I go to the my markets$/) do
  visit user_markets_path(@user)
end

When(/^I click on edit a market$/) do
  click_on "Edit"
end

When(/^I fill the name field with a new name$/) do
  fill_in "Name",  with: "New dummy Market"
end

When(/^I click on update market$/) do
  click_button "Update Market"
end

Then(/^I should see my personal market page with the new name$/) do
  expect(page).to have_content "New dummy Market"
end



Then(/^I should see the lists of markets$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content @user.email
end



Then(/^I should be notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
end

When(/^I click the delete button$/) do
  click_on "Delete"
end

Then(/^I should go to the market manager page$/) do
end

Then(/^I should not see the market$/) do
  expect(page).not_to have_content "Dummy Market"
end


Given(/^There are some markets$/) do
  FactoryGirl.create(:market, :name => "Market one")
  FactoryGirl.create(:market, :name => "Market two")
  Market.es.index.refresh
end

And(/^I am in the search page$/) do
  visit "/"
  click_on "Markets"
end

When(/^I fill the search field$/) do
  fill_in "query",  with: "one"
end

When(/^I click search$/) do
  click_on "Search" 
end

Then(/^I should see the results of my search$/) do
  expect(page).to have_content "Market one"
  expect(page).not_to have_content "Market two"
  Market.es.index.reset
end
