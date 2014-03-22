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
