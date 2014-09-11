Given(/^I have access to users management$/) do
  step "I am logged in as an admin"
end

Then(/^I should see the list of users$/) do
  expect(page).to have_content @user_0.email
  expect(page).to have_content @user_1.email
end

When(/^I delete one user$/) do
  within(:css, "#user_#{@user_1.id}") do
    find(".table-button-delete").click
  end
end

Then(/^I should not see the user$/) do
  expect(page).to have_content @user_0.email
  expect(page).not_to have_content @user_1.email
end

When(/^I desactivate one user$/) do
  within(:css, "#user_#{@user_1.id}") do
    find(".table-button-switch-inactive").click
  end
end

Then(/^It should have inactive state$/) do
  step "I go to Users"
  within(:css, "#user_#{@user_1.id}") do
    expect(page).to have_content "Inactive"
  end
end

Given(/^A normal user$/) do
  @user = create(:user, :normal)
end

When(/^I make it admin$/) do
  visit change_user_role_path @user
  click_on "Make admin"
end

Then(/^It should have admin role$/) do
  within(:css, "#user_#{@user.id}") do
    expect(page).to have_content "admin"
  end
end

Given(/^A admin user$/) do
  @user = create(:user, :admin)
end

When(/^I make it normal$/) do
  visit change_user_role_path @user
  click_on "Make regular"
end

Then(/^It should have normal role$/) do
  within(:css, "#user_#{@user.id}") do
    expect(page).to have_content "normal"
  end
end

Given(/^a user is in its profile page$/) do
  step "I am a registered user"
  step "I sign in"
  visit user_path(@user)
  click_on "Edit subscription plan"
end

Then(/^I subscribe again$/) do
  visit user_path(@user)
  click_on "Edit subscription plan"
  step "a user submits for subscription with valid data"
  step "he is premium"
end


When(/^he wants to become premium$/) do
  find_by_id("accept_terms").click
  click_on "Go PRO"
end

Then(/^he needs to introduce his credit card data$/) do
  fill_in "Card holder name", with: "Dan North"
  fill_in "Card number", with: 4111111111111111
  select "5", :from => "expiration_month"
  select "2022", :from => "expiration_year"
  fill_in "cvc", with: 212
end

Given(/^a user submits for subscription with valid data$/) do
  visit user_subscription_path @user
  step "he needs to introduce his credit card data"
  click_on "Subscribe"
end

Then(/^he is notified for a successful subscription$/) do
  expect(find('#notice')).to have_content "Your operation has been done successfully"
end

Given(/^an inactive user$/) do
  @user = create(:user, :status => "inactive")
end

When(/^I activate it$/) do
  within(:css, "#user_#{@user.id}") do
    find(".table-button-switch-active").click
  end
end

Then(/^It should have active state$/) do
  step "I go to Users"
  within(:css, "#user_#{@user.id}") do
    expect(page).to have_content "Active"
  end
end

Then(/^he is premium$/) do
  expect(page).to have_css '.premium-star'
end

When(/^I cancel my subscription$/) do
  visit user_subscription_plan_path @user
  click_on "Unsubscribe"
end

Then(/^I am a regular user$/) do
  expect(page).to_not have_css '.premium-star'
end

Given(/^I can create a PRO market$/) do
  visit new_user_market_path(@user)
  page.should have_css("#form-link-coupon.enabled")
end

Given(/^there is another user$/) do
  @other_user = create(:user, :email => "other_dummy@gmail.com", :nickname => "Other User")
end

Given(/^I go to the page of the other user$/) do
  visit user_path(@other_user)
end

Then(/^I should be able to follow the other user$/) do
  page.should have_css(".user-follow-icon")
end

Then(/^I follow the other user$/) do
  click_on "Follow"
end

Then(/^I should see my name on the list of the followers$/) do
  within(:css, ".followers") do
    page.should have_content(@user.nickname)
  end
end

Then(/^I go to my profile page$/) do
  visit user_path(@user)
end

Then(/^I should see that I am following the other user$/) do
  within(:css, ".following") do
    page.should have_content(@other_user.nickname)
  end
end

Given(/^I am following the other user$/) do
  step "I follow the other user"
end

Then(/^I should be able to unfollow the other user$/) do
  page.should have_css(".user-unfollow-icon")
end

Then(/^I unfollow the other user$/) do
  click_on "Unfollow"
end

Then(/^I should not see my name on the list of the followers$/) do
  within(:css, ".followers") do
    page.should_not have_content(@user.nickname)
  end
end

Then(/^I should not see that I am following the other user$/) do
  within(:css, ".following") do
    page.should_not have_content(@other_user.nickname)
  end
end

Then(/^I should not be able to follow myself$/) do
  page.should_not have_css(".user-follow-icon")
end

Given(/^I am a new user with profile photo$/) do
  step "I am a registered user with empty profile"
  step "I sign in"
end

Then(/^I should see the notification of uncomplete profile in dashboard$/) do
  visit user_dashboard_path(@user)
  expect(page).to have_content 'Your profile is not complete. Please update your profile'
end

Then(/^I click the link to add nickname and description$/) do
  click_on "update your profile"
  fill_in "Nickname",  with: "Dummy Nickname"
  fill_in "Description",  with: "New Dummy Bargain"
  click_on "Update"
end

Then(/^I should be notified that my profile has been updated$/) do
  expect(page).to have_content 'Your user was updated successfully'
end

Then(/^I should not see the notification of uncomplete profile in dashboard$/) do
  visit user_dashboard_path(@user)
  expect(page).to_not have_content 'Your profile is not complete. Please update your profile'
end

Given(/^I am a user without profile photo$/) do
  step "I am a registered user without featured photo"
  step "I sign in"
end
