Given(/^I am logged in as a moderator$/) do
  @moderator = FactoryGirl.create(:user, :moderator)
  log_in_as @moderator
end

When(/^I visit a market$/) do
  user = FactoryGirl.create(:user)
  market = FactoryGirl.create(:market, user: user)
  @comment = FactoryGirl.create(:comment, market: market)
  visit user_market_path user, market
end

Then(/^I can delete the market comments$/) do
  within(:css, ".market-comments") do
    click_link "Delete"
  end
  expect(page).to_not have_content @comment.body
end 