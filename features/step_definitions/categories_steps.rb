When(/^I add a category$/) do
  step "I go to Category list"
  find('.new').click  
  fill_in "Name",  with: "Dummy Category"
  fill_in "Style",  with: "map_style"
  fill_in "Glyph",  with: "category_glyph"
  fill_in "Color",  with: "#123456"
  click_on "Create"
end

Then(/^I should see the category in the category list$/) do
  step "I go to Category list"
  expect(page).to have_content "Dummy Category"
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
  click_on "Update"
end

Then(/^I should see the category with the new name in the category list$/) do
  step "I go to Category list"
  expect(page).to have_content "New Dummy Category"
end

When(/^I browse one category$/) do
  step "I go to Category list"
  within(:css, "#category_#{@category.id}") do
    click_link @category.name
  end
end

Then(/^I should see the markets of the category$/) do
  expect(page).to have_content "My market"
  expect(page).to have_content "My market description"
end

Then(/^I should see the correct style in the map$/) do
  visit map_path
  expect(page).to have_css('#dummy-category')
  page.should have_css('.category_glyph')
  first(".theme-styled").click
end

Then(/^I should see the category with map and glyph in the category list$/) do
  visit categories_path
  page.should have_css('.category_glyph')
  expect(page).to have_content "map_style"
 # expect(page).to have_css('button[style*=background-color:#123456')
end

Given(/^There are some markets with the categories$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click on a category on the home page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see all the available markets of this category$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see that the filter button of this category is selected$/) do
  pending # express the regexp above with the code you wish you had
end

