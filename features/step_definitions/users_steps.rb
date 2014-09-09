Given(/^I have access to users management$/) do
  step "I am logged in as an admin"
end

Then(/^I should see the list of users$/) do
  expect(page).to have_content @user_0.email
  expect(page).to have_content @user_1.email
end

Then(/^I should see the list of users grouped by role$/) do
  @users.each do |user|
    within(".#{user.role}") do
      page.should have_css(".user", text: user.email)
    end
  end
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
  within(:css, ".admin") do
    expect(page).to have_content @user.email
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
  within(:css, ".normal") do
    expect(page).to have_content @user.email
  end
end

Given(/^a user is in its profile page$/) do
  step "I am a registered user"
  step "I sign in"
  visit user_path(@user)
end

When(/^he wants to become premium$/) do
  click_on "Become premium"
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
  expect(find('#notice')).to have_content "You have become premium successfully."
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
