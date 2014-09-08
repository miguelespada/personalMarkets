When(/^I add a wish$/) do
  step "I go to my wishlist"
  find('.new').click  
  fill_in "Description",  with: "Dummy Wish"
  fill_in "Tags", with: "tag1,tag2"
  click_on "Create"
end

When(/^I see the wish$/) do
  expect(page).to have_content "Dummy Wish"
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
  within(:css, "#wish_#{@wish.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the wish in my wishlist$/) do
  step "I go to my wishlist"
  expect(page).not_to have_content @wish.description
end

When(/^I edit a wish$/) do
  step "I go to my wishlist"
  find('.edit').click  
  fill_in "Description",  with: "New Dummy Wish"
  fill_in "Tags", with: "tag1,tag2,tag3"
  click_on "Update"
end


Then(/^I should see the wish with the new description in the wish list$/) do
  step "I go to my wishlist"
  expect(page).to have_content "New Dummy Wish"
  expect(page).to have_content "tag1"
  expect(page).to have_content "tag3"
end

When(/^I got to a wish page$/) do
  visit wish_path(@wish)
end

Then(/^I can recommend a market to a wish$/) do
  select @market_0.name, :from => "market_market_id"
  click_on "Recommend"

  within(:css, ".recomendations") do
    expect(page).to have_content @market_0.name
  end
end


