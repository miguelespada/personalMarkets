Given(/^I sign up$/) do
  visit "/"
  click_on "Sign in"
  within(:css, ".user-session-menu") do
    click_on "Sign up"
  end
  within(:css, "#sign-up-form") do
    fill_in "Email",  with: "dummy@gmail.com"
    fill_in "Password",  with: "password", :match => :prefer_exact
    fill_in "Password confirmation",  with: "password"  
    click_on "Sign up"
  end
 
end

Given(/^I am a registered user$/) do
  @user = create(:user, :email => "dummy@gmail.com")
end

Given(/^I sign in$/) do
  log_in_as @user
end

Given(/^I am logged in$/) do
  step "I am a registered user"
  step "I sign in"
end

Given(/^I am logged in as premium$/) do
  step "I am a premium user"
  step "I sign in"
end

Given(/^I am not logged in$/) do

end

Given(/^I am a premium user$/) do
  @user = create(:user, :premium, :email => "dummy@gmail.com")
end

When(/^I sign out$/) do
  click_on @user.email
  click_on "Sign out"
end

Given(/^I log in as the first user$/) do
  log_in_as @user_0
end

Given(/^I sign in as the other user$/) do
  log_in_as @user_1
end

Given(/^I am logged in as an admin$/) do
  @admin = create(:user, :admin)
  log_in_as @admin
end
