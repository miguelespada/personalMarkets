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

When(/^I go to the my markets$/) do
  visit user_markets_path(@user)
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
  within(:css, "div#latitude") do
    expect(page).to have_content "40"
  end 
  within(:css, "div#longitude") do
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

When(/^I remove one tag$/) do
  save_and_open_page
  find(:xpath, "//input[@name='hidden-market[tags]']").set "tag_1,tag_3"
end

Then(/^I should see my personal market page without the tag$/) do
  expect(page).to have_content "tag_1"
  expect(page).to have_content "tag_2"
  expect(page).to have_content "tag_3"
end

When(/^there are some tagged markets$/) do
  @market_1 = FactoryGirl.create(:market, :name => "Market one", :tags => "one, two, three")
  @market_2 = FactoryGirl.create(:market, :name => "Market two", :tags => "one, three")
  @market_3 = FactoryGirl.create(:market, :name => "Market thre", :tags => "four")
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


Then(/^I should see tag as suggested tag$/) do
  within(:css, "div#suggested-tags") do
      expect(page).to have_content "one"
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

