When(/^I add a tag$/) do
  step "I go to Tag list"
  find('.new').click
  fill_in "Name",  with: "Dummy Tag"
  click_on "Create"
end

Then(/^I should see the tag in the tag list$/) do
  step "I go to Tag list"
  expect(page).to have_content "Dummy Tag"
end


When(/^I delete a tag$/) do
  step "I go to Tag list"
  within(:css, "#tag_#{@tag.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the tag in the tag list$/) do
  step "I go to Tag list"
  expect(page).not_to have_content "Dummy Tag"
end


When(/^I edit a tag$/) do
  step "I go to Tag list"
  within(:css, "#tag_#{@tag.id}") do
    find('.edit').click
  end
  fill_in "Name",  with: "New Dummy Tag"
  click_on "Update"
 end

Then(/^I should see the tag with the new name in the tag list$/) do
  step "I go to Tag list"
  expect(page).to have_content "New Dummy Tag"
end

When(/^I browse the tag$/) do
  step "I go to Tag list"
  click_on @tag.name
end

Then(/^I should see the markets tagged with the tag$/) do
  expect(page).to have_content "My market"
  expect(page).to have_content "My market description"
end

