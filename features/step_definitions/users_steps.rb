Given(/^I am in the home page$/) do
  visit "/"
end

When(/^I click on sign up$/) do
  click_on "Sign up"
end

When(/^I fill in the email and password$/) do
  fill_in "Email",  with: "dummy@email.com"
  fill_in "Password",  with: "password", :match => :prefer_exact
  fill_in "Password confirmation",  with: "password"  
end

When(/^I click on the sign up button$/) do
  click_button "Sign up"
end

Then(/^I should be notified that the user has been added$/) do
  expect(page).to have_content "You have signed up successfully"
end

Then(/^I should see that I am logged$/) do
  expect(page).to have_content "You are logged as: dummy@email.com"
end


Given(/^I am a registered user$/) do
  @user = FactoryGirl.create(:user)
  visit "/"
end

Then(/^I click to sign in$/) do
  click_link "Sign in"
end

Then(/^I fill a valid email and password$/) do
  fill_in "Email",  with: @user.email
  fill_in "Password",  with: "password", :match => :prefer_exact
  click_button "Sign in"
end


Then(/^I should see that I am logged as myself$/) do
  expect(page).to have_content "You are logged as: " + @user.email
end

When(/^I click on sign out$/) do
  click_on "Sign out"
end

Then(/^I should be notified that the I signed out$/) do
  expect(page).to have_content "Signed out successfully."
end

Then(/^I should see that that I am not logged$/) do
  expect(page).not_to have_content "You are logged as: dummy@email.com"
end


Given(/^there are some users$/) do
  @users = FactoryGirl.create_list(:user, 5)
end

When(/^I click on User List$/) do
  click_on "Users"
end

Then(/^I should see the list of users$/) do
  @users.each do |u|
    expect(page).to have_content u.email
  end
end

Given(/^there is one user$/) do
  @user = FactoryGirl.create(:user)
end 

When(/^I go to the user list$/) do
  visit users_path
end

When(/^I click on delete user$/) do
  click_on "Delete"
end

Then(/^I should not see the deleted user$/) do
    expect(page).not_to have_content @user.email
end


Given(/^the user has one market$/) do
  @market = FactoryGirl.create(:market, :name => "Dummy Market", :user => @user)
end

When(/^I go to the market list$/) do
  visit markets_path
end

When(/^I should not see the user's market$/) do
  expect(page).not_to have_content "Dummy Market"
end



