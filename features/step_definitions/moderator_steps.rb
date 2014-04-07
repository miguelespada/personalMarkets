Given(/^I am logged in as a moderator$/) do
  @moderator = create(:user, :moderator)
  log_in_as @moderator
end

When(/^I visit a market$/) do
  user = create(:user)
  market = create(:market, :with_featured_image, user: user)
  @comment = create(:comment, market: market)
  visit user_market_path user, market
end

Then(/^I can delete the market comments$/) do
  within(:css, ".market-comments") do
    click_link "Delete"
  end
  expect(page).to_not have_content @comment.body
end 

Then(/^I can delete the market picture$/) do
  within(:css, '.market-featured-photo') do
    expect(page).to have_link "Delete"
    click_link "Delete"
  end
  within(:css, '.market-featured-photo') do
    expect(page).to_not have_css('img')
    expect(page).to_not have_link "Delete"
  end
end

