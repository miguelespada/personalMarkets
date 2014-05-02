When(/^I add a wish$/) do
  step "I go to my wishlist"
  find('.new').click  
  fill_in "Description",  with: "Dummy Wish"
  fill_in "Tags", with: "tag1,tag2"
  click_on "Create Wish"
end

When(/^I see the wish$/) do
  expect(page).to have_content "Dummy Wish"
  expect(page).to have_content "tag1"
  expect(page).to have_content "tag2"
end

Then(/^I should see the wish in my wishlist$/) do
  step "I go to my wishlist"
  step "I see the wish"
end

Then(/^I should see the wish in the general wishlist$/) do
  step "I go to wishlist"
  step "I see the wish"
end

When(/^I delete a wish$/) do
  step "I go to my wishlist"
  save_and_open_page
  within(:css, "#wish_#{@wish.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the wish in my wishlist$/) do
  step "I go to my wishlist"
  expect(page).not_to have_content @wish.description
end