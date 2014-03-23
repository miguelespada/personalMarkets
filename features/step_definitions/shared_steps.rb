Given(/^There are some indexed markets$/) do
  @category = FactoryGirl.create(:category)
  @market_0 = FactoryGirl.create(:market, :name => "Market one", 
              :category => @category, 
              :tags => "one, two, three")
  @market_1 = FactoryGirl.create(:market, :name => "Supermarket one", 
              :date => "13/05/2014", 
              :tags => "one, three")
  @market_2 = FactoryGirl.create(:market, :name => "Market two", 
              :date => "17/07/2014", 
              :tags => "two, three")
  @market_3 = FactoryGirl.create(:market, :name => "Market three", 
              :date => "20/09/2014")
  @market_4 = FactoryGirl.create(:market, :description => "Description three")
  @market_5 = FactoryGirl.create(:market, :description => "Description one")

  Market.reindex
end

Given(/^I sign up$/) do
  visit "/"
  within(:css, ".user-session-menu") do
    click_on "Sign up"
  end
  fill_in "Email",  with: "dummy@email.com"
  fill_in "Password",  with: "password", :match => :prefer_exact
  fill_in "Password confirmation",  with: "password"
  within(:css, ".new_user") do
    click_on "Sign up"
  end
end

Given(/^I am a registerd user$/) do
  @user = FactoryGirl.create(:user)
end

Given(/^I sign in$/) do
  visit "/"
  within(:css, ".user-session-menu") do
    click_on "Sign in"
  end
  fill_in "Email",  with: @user.email
  fill_in "Password",  with: @user.password, :match => :prefer_exact
  within(:css, ".new_user") do
    click_on "Sign in"
  end
end

Given(/^I am logged in$/) do
  step "I am a registerd user"
  step "I sign in"
end

Given(/^I have one market$/) do
  @market = FactoryGirl.create(:market, :user => @user)
  @user.markets << @market
end

Given(/^There is someone else's market$/) do
  user = FactoryGirl.create(:user)
  @some_market = FactoryGirl.create(:market, :user => user)
end

