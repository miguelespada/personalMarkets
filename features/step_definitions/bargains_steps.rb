When(/^I add a bargain$/) do
  step "I go to my bargain list"
  find('.new').click  
  fill_in "Description",  with: "Dummy Bargain"
  click_on "Create"
end

When(/^I see the bargain$/) do
  expect(page).to have_content "Dummy Bargain"
end

Then(/^I should see the bargain in my bargain list$/) do
  step "I go to my bargain list"
  step "I see the bargain"
end

Then(/^I should see the bargain in the general bargain$/) do
  step "I go to bargain list"
  step "I see the bargain"
end

When(/^I delete a bargain$/) do
  step "I go to my bargain list"
  within(:css, "#bargain_#{@bargain.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the bargain in my bargain list$/) do
  step "I go to my bargain list"
  expect(page).not_to have_content @bargain.description
end

When(/^I edit a bargain$/) do
  step "I go to my bargain list"
  find('.edit').click  
  fill_in "Description",  with: "New Dummy Bargain"
  click_on "Update"
end

Then(/^I should see the bargain with the new description in the bargain list$/) do
  step "I go to my bargain list"
  expect(page).to have_content "Dummy Bargain"
end

When(/^I go to a bargain page$/) do
  visit bargain_path(@bargain)
end

Then(/^I should be able to comment the bargain$/) do
  page.has_css?('fb-comments')
  page.has_css?('fb-like')
end

Given(/^I have nine bargains$/) do
  9.times do
    step "There are some bargains"
  end
end

When(/^I try to add another bargain$/) do
  step "I go to my bargain list"
  find('.new').click
end

Then(/^I should be notified that I can have ten bargains only$/) do
  expect(page).to have_content "Currently you have 10 bargains. Each user can have 10 bargains only"
end