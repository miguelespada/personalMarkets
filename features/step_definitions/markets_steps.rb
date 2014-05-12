When(/^I create a market$/) do
  find(".add_market_button").click

  within(:css, "#new_market") do
    fill_in "Name",  with: "Dummy Market"
    fill_in "City",  with: "Madrid"
    click_on "Create Market"
  end
end

Then(/^I should see the market page$/) do
    expect(page).to have_content "Dummy Market"
    expect(page).to have_content @user.email
    expect(page).to have_content "Uncategorized"
    expect(page).to have_content "Madrid"
end

Then(/^I can edit the market$/) do
  within(:css, ".market-actions") do
    expect(page).to have_link "Edit"
  end
end

When(/^I edit the market$/) do
  step "I change market info"
end

When(/^I edit my market$/) do
  visit market_path @market
  step "I change market info"
end

When(/^I change market info$/) do

  within(:css, ".market-actions") do
    click_on "Edit"
  end
  fill_in "Name",  with: "New dummy Market"
  within(:css, ".market_description") do
    fill_in "Description",  with: "New dummy description"
  end
  click_on "Update Market"
end


Then(/^I see the market page with the new data$/) do
  expect(page).to have_content "New dummy Market"
  expect(page).to have_content "New dummy description"
end

When(/^I delete my market$/) do
  visit market_path @market
  within(:css, '.market-actions') do
    click_on "Delete"
  end
end

Then(/^I should not see the market in my markets list$/) do
  visit user_markets_path(@user)
  expect(page).not_to have_content @market.name
  expect(page).not_to have_content @market.description
end

Then(/^I should see the market in my markets list$/) do
  visit user_markets_path(@user)
  expect(page).to have_content @market.name
  expect(page).to have_content @market.description
end

Then(/^I should see it in my markets$/) do
  visit user_markets_path @user

  expect(page).to have_content "Dummy Market"
end

Then(/^I am notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
end

Given(/^I have some markets$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc"
    )
  @user.markets << @market
  @market = create(
    :market, :user => @user, 
    :name => "market 2", 
    :description => "market 2 desc")
  @user.markets << @market
end

Given(/^I have some published markets$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => :published
    )
  @user.markets << @market
  @market = create(
    :market, :user => @user, 
    :name => "market 2", 
    :description => "market 2 desc",
    :state => :published)
  @user.markets << @market
end

When(/^I go to my markets list$/) do
  visit user_markets_path @user
end

Then(/^I see their names and descriptions$/) do
  expect(page).to have_content "market 1"
  expect(page).to have_content "market 1 desc"
  expect(page).to have_content "market 2"
  expect(page).to have_content "market 2 desc"
end

Then(/^I see an edit button$/) do
  all('.market-gallery-item').each do |item|
    expect(item).to have_link "Edit"
  end
end

Then(/^I see a archive button$/) do
  all('.market-gallery-item').each do |item|
    expect(item).to have_link "Archive"
  end
end

Then(/^I see a show button$/) do
  all('.market-gallery-item').each do |item|
    expect(item).to have_link "Show"
  end
end

When(/^I like the market$/) do
  visit published_markets_path
  within(:css, "#market_#{@market_0.id}") do
    click_on "Like"
  end
end

Then(/^The number of likes increment$/) do
  visit published_markets_path
  within(:css, "#market_#{@market_0.id} .like-counter") do
    expect(page).to have_content "1"
  end
end

Then(/^I cannot like that market again$/) do
  visit published_markets_path
  within(:css, "#market_#{@market_0.id}") do
    expect(page).to have_link 'Unlike'
    expect(page).not_to have_link 'Like'
  end
end

Then(/^I cannot unlike that market again$/) do
  visit published_markets_path
  within(:css, "#market_#{@market_0.id}") do
    expect(page).not_to have_link 'Unlike'
    expect(page).to have_link 'Like'
  end
end

When(/^I unlike the market$/) do
  visit published_markets_path
  within(:css, "#market_#{@market_0.id}") do
    click_on "Unlike"
  end
end

Then(/^The number of likes decrement$/) do
  visit published_markets_path
  within(:css, "#market_#{@market_0.id} .like-counter") do
    expect(page).to have_content "0"
  end
end

When(/^I visit a market page$/) do
  visit market_path @some_market
end

Then(/^I should see the full description of the market except the address$/) do
  expect(page).to_not have_css '.market-location'
end


Then(/^I have a draft market$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc"
    )
  @user.markets << @market
end

Given(/^I have a draft pro market$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :pro => true
    )
  @user.markets << @market
end

When(/^I go the market page$/) do
  visit market_path @market
end

Then(/^I can publish it$/) do
  within(:css, '.market-actions') do
    expect(page).to have_link "Publish"
  end
end

When(/^I publish the market$/) do
  click_on "Publish"
end

Then(/^I see a success publishing notification$/) do
  expect(page).to have_content "Market successfully published."
end


Then(/^I cannot publish it again$/) do
  visit market_path @market
  within(:css, '.market-actions') do
    expect(page).to_not have_link "Publish"
  end
end

When(/^I archive the market$/) do
  click_on "Archive"
end

When(/^I visit a published market$/) do
  market = create(
    :market, 
    :user => create(:user), 
    :name => "market 1", 
    :description => "market 1 desc",
    :state => "published"
    )
  visit market_path market
end

When(/^I delete the image$/) do
  within(:css, '.market-featured-photo') do
    click_on "Delete"
  end
end

Then(/^I cannot see it in the market page$/) do
  within(:css, '.market-featured-photo') do
    page.should have_css('img[alt="Default image"]') 
  end
end

When(/^I archive it$/) do
  visit market_path @market
  click_on "Archive"
end

Then(/^It is not visible in guest markets$/) do
    visit published_markets_path
    expect(page).to_not have_content "market 1"
end


Then(/^I see it in the published markets$/) do
  visit published_markets_path
  expect(page).to have_content @market.name
end

Given(/^I have a draft market with a coupon$/) do
  @market = create(
    :market, 
    :user => @user, 
    :name => "market 1", 
    :description => "market 1 desc",
    :coupon => create(:coupon)
    )
  @user.markets << @market
end

Given(/^I have a regular market with a coupon$/) do
  @market = create(:market, :state => "published", :user => @user, :coupon => create(:coupon))
end

When(/^I make it PRO$/) do
  visit market_path @market
  click_on "Go PRO"
  step "he needs to introduce his credit card data"
  click_on "Pay"
end

Then(/^I should see a warning about coupon visibility$/) do
  expect(page).to have_content "In order to publish a market with a coupon you should make it PRO or become PREMIUM. Otherwise the coupon won't be available."
end

Then(/^Its coupon is visible$/) do
  expect(page).to have_css ".market-coupon"
end

Given(/^my published market$/) do
  step "I am logged in"
  @market = create(:market, :state => "published", :user => @user, :coupon => create(:coupon))
end

When(/^I unpublish it$/) do
  visit market_path @market
  click_on "Unpublish"
end

Then(/^It does not appear in navegable markets$/) do
  visit published_markets_path
  expect(page).to_not have_content "My market"
end

When(/^I go to the edit market page$/) do
  visit market_path @market
  step "I click on edit the market"
end

Then(/^I should see the link of photo gallery is disabled$/) do
  page.should have_css('li#form-link-gallery.disabled')
  step "I click on the link of photo gallery"
  step "I should not be able to access photo gallery"
end

Then(/^I click on the link of photo gallery$/) do
  find('#form-link-gallery').click
end

Then(/^I should not be able to access photo gallery$/) do
  page.should_not have_css('div#form-market-photos.active')
end

Then(/^I click on edit the market$/) do
  within(:css, ".market-actions") do
    click_on "Edit"
  end
end

Then(/^I should see the link of photo gallery is enabled$/) do
  page.should have_css('li#form-link-gallery.enabled')
  step "I click on the link of photo gallery"
  step "I should be able to access photo gallery"
end

Then(/^I should be able to access photo gallery$/) do
  page.should have_css('div#form-market-photos.active')
end

Then(/^The market becomes staff pick$/) do
  visit market_path @market_0
  page.should have_css('.staff_pick')
end


Then(/^The market is not staff pick$/) do
  visit market_path @market_0
  page.should_not have_css('.staff_pick')
end
