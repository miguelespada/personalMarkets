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
  within(:css, "div#favorites") do
    page.should have_content @market.name
  end
end

Then(/^The market gets my like$/) do
  pending # express the regexp above with the code you wish you had
end

