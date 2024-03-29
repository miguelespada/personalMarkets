When(/^I create a coupon$/) do
  find_by_id('form-link-coupon').click
  within(:css, "#form-market-coupon") do
    fill_in "Description",  with: "My dummy coupon"
    select "10", :from => "Price"
    select "20", :from => "Available"
  end 
  click_on "Update Market"
end

When(/^I should see the coupon in the market page$/) do
  step "I visit the market page"

  expect(page).to have_content @market.name
  expect(page).to have_content "My dummy coupon"
  expect(page).to have_content "10"
  expect(page).to have_content "20"
end

Given(/^I buy some coupons$/) do
  visit buy_coupon_form_path @coupon
  select "2"
  find_by_id('premium_accept_term').click
  click_on "Buy"
  step "he needs to introduce his credit card data"  
  click_on "Pay"
end

Then(/^I should see the coupon transactions in my coupon transactions$/) do
  visit bought_coupons_by_user_path @user
  expect(page).to have_content "Dummy coupon"
end

Then(/^I sign in as the market owner$/) do  
  step "I sign out"
  log_in_as @market_owner
end

Then(/^I should see the coupon transactions in the market transactions$/) do
  visit sold_coupons_by_market_path @market
  expect(page).to have_content "Dummy coupon"
  within(:css, ".buyer") do
    expect(page).to have_content @user.name
  end
  within(:css, ".seller") do
    expect(page).to have_content "You"
  end
end

When(/^All the coupons are sold$/) do
  @market.coupon.available = 0
  @market.coupon.save
end

# When(/^I try to buy the coupon$/) do
#   step "I visit the market page"
#   click_on "Buy Coupon"
# end

When(/^I should see that the coupon sold out$/) do
  step "I visit the market page"
  expect(page).to have_content "Sold out"
end

Then(/^I should see all the coupons that are emitted$/) do
  expect(page).to have_content @market.name
  expect(page).to have_content @market.user.email
  expect(page).to have_content @coupon.description
end

Given(/^a premium user's market with a coupon$/) do
  @user = create(:user, :premium)
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => :published,
    :coupon => create(:coupon)
    )
end

Then(/^I can see the coupon$/) do
  expect(page).to have_css ".market-coupon"
end

Given(/^a regular user's non pro market with a coupon$/) do
  @user = create(:user)
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => :published,
    :coupon => create(:coupon)
    )
end

Then(/^I cannot see the coupon$/) do
  expect(page).to_not have_css ".market-coupon"
end

Given(/^a regular user's pro market with a coupon$/) do
  @user = create(:user)
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => :published,
    :coupon => create(:coupon),
    :pro => true
    )
end

When(/^I edit a coupon$/) do
  find_by_id('form-link-coupon').click
  within(:css, "#form-market-coupon") do
    fill_in "Description",  with: "My edited dummy coupon"
    select "20", :from => "Price"
    select "10", :from => "Available"
  end 
  click_on "Update Market"
end

Then(/^I should see the edited coupon in the market page$/) do
  step "I visit the market page"
  expect(page).to have_content @market.name
  expect(page).to have_content "My edited dummy coupon"
  expect(page).to have_content "20"
  expect(page).to have_content "10"
end

Then(/^I should see the locator of the coupon$/) do
  expect(page).to have_content "Locator"
end

Then(/^I should not see the locator of the coupon$/) do
  expect(page).to_not have_content "Locator"
end


Given(/^Some users buy coupons$/) do
  step "I am logged in"
  step "There is a market with available coupons"
  step "I buy some coupons"
  step "I should be notified that the coupons has been bought"
  visit "/users/sign_out"

  @user2 = create(:user, :admin, :email => "dummy2@gmail.com")
  log_in_as @user2
  step "I buy some coupons"
  step "I should be notified that the coupons has been bought"
  step "I should see the coupon transactions in my coupon transactions"
  visit "/users/sign_out"

end

Then(/^The market finishes$/) do
  @market.schedule = 1.day.ago.strftime("%d/%m/%Y")
  @market.publish_date = 2.days.ago
  @market.save!
end

Then(/^As admin I can see the transactions digest$/) do
  @admin = create(:user, :admin, :email => "admin@gmail.com")
  visit "/"
  log_in_as @admin
  visit last_transactions_path
  expect(page).to have_content "Sold coupons of closed markets"
  within(:css, "#coupon-#{@market.coupon.id} .total") do
    expect(page).to have_content 44.5
  end
end



