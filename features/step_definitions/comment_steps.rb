Given(/^It has comments$/) do
  @comment = FactoryGirl.create(:comment, :market => @market)
  @market.comments << @comment
end

When(/^I visit the market page$/) do
  visit user_market_path(@user, @market)
end

Then(/^I should see the market comments$/) do
  expect(page).to have_content "My comment text 1"
end

When(/^I post a comment$/) do
  fill_in "Body", with: "My market comment"
  click_button "Post comment"
end

Then(/^It appears in the list$/) do
  step "I visit the market page"
  expect(page).to have_content "My market comment"
end