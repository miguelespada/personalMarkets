Given(/^I am in the add user page$/) do
	visit new_user_registration_path 
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

Given(/^I am in the home page$/) do
	visit "/"
end

Given(/^there are some users$/) do
  @users = FactoryGirl.create_list(:user, 5)
end

When(/^I click on User List$/) do
	click_on "Browse users"
end

Then(/^I should see the list of users$/) do
	expect(page).to have_content "User List"

  @users.each do |u|
    expect(page).to have_content u.email
  end

end

