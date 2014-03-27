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

When(/^I comment other user market$/) do
  @other_user = FactoryGirl.create(:user)
  @other_market = FactoryGirl.create(:market, :user => @other_user)
  @other_user.markets << @other_market
  step 'I visit the other market page'
  fill_in "Body", with: "Commenting other user market"
  click_button "Post comment"
end

When(/^I visit the other market page$/) do
  visit user_market_path(@other_user, @other_market)
end

Then(/^It appears in the other market list$/) do
  step 'I visit the other market page'
  expect(page).to have_content "Commenting other user market"
end

Then(/^I cant post a comment$/) do
  expect(page).to_not have_css "market-comment-form"
end