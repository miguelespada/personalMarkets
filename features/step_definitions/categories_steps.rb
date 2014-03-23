When(/^I add a category$/) do
  click_on "New"
  fill_in "Name",  with: "New dummy Category"
  click_on "Create Category"
end

Then(/^I should see the category in the category list$/) do
  step "I go to Category list"
  expect(page).to have_content "New dummy Category"
end

Then(/^I should not see the category in the category list$/) do
  step "I go to Category list"
  expect(page).not_to have_content @category.name
end

Given(/^I delete a category$/) do
  within(:css, "#category_#{@category.id}") do
    click_on "Delete"
  end
end
