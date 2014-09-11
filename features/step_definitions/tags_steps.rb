When(/^I add a tag$/) do
  step "I go to tag list"
  find('.new').click
  fill_in "Name",  with: "Dummy Tag"
  click_on "Create"
end

Then(/^I should see the tag in the tag list$/) do
  step "I go to tag list"
  expect(page).to have_content "Dummy Tag"
end


When(/^I delete a tag$/) do
  step "I go to tag list"
  within(:css, "#tag_#{@tag.id}") do
    find('.delete').click
  end
end

Then(/^I should not see the tag in the tag list$/) do
  step "I go to tag list"
  expect(page).not_to have_content "Dummy Tag"
end


When(/^I edit a tag$/) do
  step "I go to tag list"
  within(:css, "#tag_#{@tag.id}") do
    find('.edit').click
  end
  fill_in "Name",  with: "New Dummy Tag"
  click_on "Update"
 end

Then(/^I should see the tag with the new name in the tag list$/) do
  step "I go to tag list"
  expect(page).to have_content "New Dummy Tag"
end

When(/^I browse the tag$/) do
  step "I go to tag gallery"
  click_on @tag.name.upcase
end

Then(/^I should see the markets tagged with the tag$/) do
  expect(page).to have_content "My market"
  expect(page).to have_content "My market description"
end

When(/^There is a market with a suggested tag$/) do
  @tag = create(:tag, :name => "dummy tag")
  @market_owner = create(:user)
  @market = create(:market, 
    :user => @market_owner, 
    :tags => "dummy tag", 
    :name => "Dummy market")
  @market.publish
end

Then(/^I should see the market tagged with the tag$/) do
  expect(page).to have_content "Dummy market"
end

When(/^I browse another tag$/) do
  @other_tag = create(:tag, :name => "other tag")
  step "I go to tag gallery"
  click_on @other_tag.name.upcase
end

Then(/^I should not see the market tagged with the tag$/) do
  expect(page).to_not have_content "Dummy market"
end

