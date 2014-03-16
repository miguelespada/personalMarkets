Given(/^I go to category list$/) do
  visit categories_path
end

Given(/^I click on new$/) do
  click_on "New"
end

Given(/^I fill a category name$/) do
  fill_in "Name",  with: "Dummy Category"
end

When(/^I click on add category$/) do
  click_on "Create Category"
end

Then(/^I should see the category$/) do
  expect(page).to have_content "Dummy Category"
end

Then(/^The market counter of the category should be zero$/) do
  within(:css, ".market-counter") do
    expect(page).to have_content "0"
  end 
end

Then(/^I should be notified that the category has been added$/) do
  expect(page).to have_content "Category was successfully created."
end

Given(/^There is a category without markets$/) do
  @category = FactoryGirl.create(:category, :name => "Fresh category")
end

When(/^I click on delete category$/) do
  within(:css, ".category") do
    click_on "Delete"
  end
end

Then(/^I should not see the category$/) do
  expect(page).not_to have_content "Fresh category"
end

Then(/^I should be notified that the category has been deleted$/) do
  expect(page).to have_content "Category successfully deleted."
end

Given(/^there is a market$/) do
  @market = FactoryGirl.create(:market)
end

When(/^I should see the market category with the number of markets$/) do
  within(:css, ".market-counter") do
    expect(page).to have_content "1"
  end 
end

Then(/^I should see the market's category$/) do
  expect(page).to have_content @market.category.name
end

Then(/^I should be notified that the category has not been deleted$/) do
  expect(page).to have_content "Cannot delete category."
end

Then(/^should the uncategorized category$/) do
    expect(page).to have_content "Uncategorized"
end


