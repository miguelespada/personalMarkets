When(/^I like a market$/) do
  visit user_market_path(@some_market.user, @some_market)
  click_on "Like"
end

Then(/^The market is in my favorites$/) do
  visit user_path(@user)
  within(:css, "div.likes") do
    page.should have_content @some_market.name
  end
end

Then(/^The market has got a like$/) do
  visit user_market_path(@some_market.user, @some_market)
  within(:css, "div.market-likes") do
    page.should have_content @user.email
  end
end

Given(/^I have some favorite markets$/) do
  step "I like a market"
  @like = @some_market
end

Given(/^I unlike a market$/) do
  visit user_market_path(@like.user, @like)
  click_on "Unlike"
end

Then(/^The market is not in my favorites$/) do
  visit user_path(@user)
  within(:css, "div.likes") do
    page.should_not have_content @like.name
  end
end