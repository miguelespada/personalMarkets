When(/^I add a bargain$/) do
  step "I go to my bargain list"
  find('.new').click  
  fill_in "Description",  with: "Dummy Bargain"
  click_on "Create Bargain"
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
  step "I see the wish"
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
  click_on "Update Bargain"
end

Then(/^I should see the bargain with the new description in the bargain list$/) do
  step "I go to my bargain list"
  expect(page).to have_content "Dummy Bargain"
end