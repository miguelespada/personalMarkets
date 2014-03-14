Given(/^I am a register user$/) do
  @user = FactoryGirl.create(:user)
end

Given(/^I sign in$/) do
  visit "/"
  click_link "Sign in"
  fill_in "Email",  with: @user.email
  fill_in "Password",  with: "password", :match => :prefer_exact
  click_button "Sign in"
end

Given(/^There is someone else's market$/) do
  someone = FactoryGirl.create(:user)
  @market = FactoryGirl.create(:market, :name => "Dummy Market", :user => someone)
end

When(/^I go to the market page$/) do
  visit user_market_path(@market.user, @market)
end

When(/^I like the market$/) do
  click_on "Like"
end

Then(/^The market is in my favorites$/) do
  visit user_path(@user)
  page.should have_content "Favorites of #{@user.email}" 
  within(:css, "div.favorites") do
    page.should have_content @market.name
  end
end

Then(/^The market gets my like$/) do
  visit user_market_path(@market.user, @market)
  page.should have_content "Favorited by" 
  within(:css, "div.favorited") do
    page.should have_content @user.email
  end
end

When(/^I go to my favorites$/) do
  visit user_path(@user)
  page.should have_content "Favorites of #{@user.email}" 
end

When(/^I unlike the market$/) do
  click_on "Unlike"
end

Then(/^The market is not in my favorites$/) do
  visit user_path(@user)
  page.should have_content "Favorites of #{@user.email}" 
  within(:css, "div.favorites") do
    page.should_not have_content @market.name
  end
end

Then(/^The market does not have my like$/) do
  visit user_market_path(@market.user, @market)
  page.should have_content "Favorited by" 
  within(:css, "div.favorited") do
    page.should_not have_content @user.email
  end
end

Then(/^I cannot like the market again$/) do
  within("//tr[@id='market_slug_#{@market.id}']") do
    page.should_not have_content "Like"
  end
end

Then(/^I cannot unlike the market again$/) do
  within("//tr[@id='market_slug_#{@market.id}']") do
    page.should_not have_content "Unlike"
  end
end

Given(/^I have a market$/) do
  @myMarket = FactoryGirl.create(:market, :name => "Dummy Market", :user => @user)
end

Then(/^I cannot like the market$/) do
  within("//tr[@id='market_slug_#{@myMarket.id}']") do
    page.should_not have_content "Unlike"
    page.should_not have_content "Like"
  end
end

When(/^The market is deleted$/) do
  click_on "Delete"
end



