Given(/^I am in my user space$/) do
  @user = FactoryGirl.create(:user)
  @category = FactoryGirl.create(:category)
  visit user_path(@user)
end
When(/^I click on add market$/) do
  click_on "Add market"
end

When(/^I fill in the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
end

When(/^I click on the save market button$/) do
  click_on "Create Market"
end

Then(/^I should see my personal market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
  expect(page).to have_content @user.email
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end


Given(/^I go to the my List of Markets$/) do
  visit user_path(@user)
  click_on "List of Markets"
end

Then(/^I should see the lists of markets$/) do
  expect(page).to have_content "Your Markets"
  expect(page).to have_content "Dummy Market"
end
