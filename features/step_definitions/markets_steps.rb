When(/^I click on add market$/) do
  click_on "Add market"
end

Given(/^There is one category$/) do
  @category = FactoryGirl.create(:category)
end

When(/^I fill in the name and description$/) do
  fill_in "Name",  with: "Dummy Market"
  fill_in "Description",  with: "Dummy description"
  select(@category.name, :from => 'Category')
end

When(/^I click on the save market button$/) do
  click_button "Create Market"
end

Then(/^I should see the market page$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content "Dummy description"
  expect(page).to have_content @user.email
end

Then(/^I should be notified that the market has been added$/) do
  expect(page).to have_content "Market was successfully created."
end


When(/^I click on edit a market$/) do
  click_on "Edit"
end

When(/^I fill the name field with a new name$/) do
  fill_in "Name",  with: "New dummy Market"
end

When(/^I click on update market$/) do
  click_button "Update Market"
end

Then(/^I should see my personal market page with the new name$/) do
  expect(page).to have_content "New dummy Market"
end

Then(/^I should see the lists of markets$/) do
  expect(page).to have_content "Dummy Market"
  expect(page).to have_content @user.email
end

Then(/^I should be notified that the market has been succesfully updated$/) do
  expect(page).to have_content "Market successfully updated."
end

When(/^I click the delete button$/) do
  click_on "Delete"
end

Then(/^I should be notified that the market has been succesfully deleted$/) do
  expect(page).to have_content "Market successfully deleted."
end

Then(/^I should not see the market$/) do
  expect(page).not_to have_content "Dummy Market"
end

When(/^I fill latitude and longitude$/) do
  fill_in "Latitude",  with: "40"
  fill_in "Longitude",  with: "-3"
end

Then(/^I should see my personal market page with the new latitude and longitude$/) do
  within(:css, "div.market-latitude") do
    expect(page).to have_content "40"
  end 
  within(:css, "div.market-longitude") do
    expect(page).to have_content "-3"
  end 
end

When(/^I fill the tag list$/) do
  fill_in "Tags", with: "tag_1, tag_2, tag_3"
end

Then(/^I should see my personal market page with the tags$/) do
  expect(page).to have_content "tag_1"
  expect(page).to have_content "tag_2"
  expect(page).to have_content "tag_3"
end



Then(/^I should see my personal market page without the tag$/) do
  expect(page).to have_content "tag_1"
  expect(page).to have_content "tag_2"
  expect(page).to have_content "tag_3"
end

When(/^there are some tagged markets$/) do
  @market_1 = FactoryGirl.create(:market, :name => "Market one", :tags => "one, two, three")
  @market_2 = FactoryGirl.create(:market, :name => "Market two", :tags => "one, three")
  @market_3 = FactoryGirl.create(:market, :name => "Market three", :tags => "four")
  Market.reindex
end



When(/^I go to tag list$/) do
  visit tags_path
end

Then(/^I can see all the tags$/) do
  expect(page).to have_content "one"
  expect(page).to have_content "two"
  expect(page).to have_content "three"
end

When(/^I click on a tag$/) do
  click_link "one"
end

Then(/^I see the markets matching the tag$/) do
  expect(page).to have_content "Market one"
end

When(/^I click star tag$/) do
  within(:css, "span#one") do
      click_link "star"
  end 
end


When(/^I go to add market$/) do
  visit "/"
  click_on "Add market"
end

When(/^I click unstar tag$/) do
  within(:css, "span#one") do
      click_link "unstar"
  end 
end

When(/^I remove one tag$/) do
  find(:xpath, "//input[@name='hidden-market[tags]']").set "tag_1,tag_3"
end

Then(/^I should see its tags in the form$/) do
  page.should have_css('form[data-tags=\'["tag_1", "tag_2", "tag_3"]\']')
end

Given(/^I go to edit my market$/) do
  visit edit_user_market_path(@user, @myMarket)
end

When(/^I fill the date field$/) do
    fill_in "Date",  with: "13/05/2014"
end

Then(/^I should see the calendar with my calendar$/) do
    within(:css, "div.calendar") do
      expect(page).to have_content @myMarket.name
      expect(page).to have_content "13/05/2014"
    end 
end

Given(/^I am in the search page$/) do
  visit search_path
end

Given(/^There are some markets with date$/) do
   @market_1 = FactoryGirl.create(:market, :name => "Market one", :date => "13/05/2014")
   @market_2 = FactoryGirl.create(:market, :name => "Market two", :date => "17/07/2014")
   @market_3 = FactoryGirl.create(:market, :name => "Market three", :date => "20/09/2014")
   Market.reindex
end

When(/^I select a 'from' date$/) do
    fill_in "from",  with: "16/05/2014"
end

When(/^I click on search$/) do
  click_button "Search"
end

Then(/^I should see the markets that match my search with date$/) do
  expect(page).to have_content "Market three"
  expect(page).to have_content "Market two"
end
