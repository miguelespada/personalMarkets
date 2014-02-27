Given(/^I am in the add market page$/) do
#  @categories = FactoryGirl.create_list(:category, 5)
  @category = FactoryGirl.create(:category, name: "Dummy category 1")
  visit '/markets/new'
end

When(/^I fill in the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
end

When(/^I fill the category$/) do
  #select @categories.last.name
  select @category.name

end

When(/^I click on the save market button$/) do
  click_on "Create Market"
end

Then(/^I should see my personal market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
  expect(page).to have_content @category.name
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end



Given(/^I am in my personal market page$/) do
  @market = FactoryGirl.create(:market)
  
  visit market_path(@market)
end

When(/^I upload a photo$/) do
	pending
	#click_on "Save" 

end

Then(/^I should see the photo$/) do
 # pending # express the regexp above with the code you wish you had
end

Then(/^I should be notified that the featured photo has been added$/) do
 pending # express the regexp above with the code you wish you had
end