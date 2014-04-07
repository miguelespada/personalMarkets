Given(/^I sign up$/) do
  visit "/"
  within(:css, ".user-session-menu") do
    click_on "Sign up"
  end
  fill_in "Email",  with: "dummy@gmail.com"
  fill_in "Password",  with: "password", :match => :prefer_exact
  fill_in "Password confirmation",  with: "password"
  within(:css, ".new_user") do
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

When(/^I sign out$/) do
  within(:css, ".user-session-menu") do
    click_on "Sign out"
  end
end

Given(/^I log in as the first user$/) do
  log_in_as @user_0
end

Given(/^I sign in as the other user$/) do
  log_in_as @user_1
end
