When(/^I add a category$/) do
  step "I go to Category list"
  find('.new').click  
  fill_in "Name",  with: "Dummy Category"
  click_on "Create Category"
end

Then(/^I should see the category in the category list$/) do
  step "I go to Category list"
  expect(page).to have_content @category.name
end

Given(/^I delete a category$/) do
  step "I go to Category list"
  within(:css, "#category_#{@category.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the category in the category list$/) do
  step "I go to Category list"
  expect(page).not_to have_content @category.name
end

When(/^I edit a category$/) do
  step "I go to Category list"
  within(:css, "#category_#{@category.id}") do
    find('.edit').click  
  end

  fill_in "Name",  with: "New Dummy Category"
  click_on "Update Category"
end

Then(/^I should see the category with the new name in the category list$/) do
  step "I go to Category list"
  expect(page).to have_content "New Dummy Category"
end

When(/^I browse one category$/) do
  step "I go to Category list"
  within(:css, "#category_#{@category.id}") do
    click_on @category.name
  end
end

Then(/^I should see the markets of the category$/) do
  expect(page).to have_content "My market"
  expect(page).to have_content "My market description"
end