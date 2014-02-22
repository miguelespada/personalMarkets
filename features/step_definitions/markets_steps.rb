
When(/^I click "(.*?)"$/) do |place|
  click_link place
end

Then(/^I should see the link "(.*?)"$/) do |label|
	page.should have_link(label)
end

Given(/^I am in Markets/) do
	visit "/markets/"
end

Then(/^I should see the field "(.*?)"$/) do |label|
	page.should have_field(label)
end
Then(/^I should see the button "(.*?)"$/) do |label|
	page.should have_button(label)
end


Given(/^I am in Create New Market/) do
	visit "/markets/new"
end

When(/^I fill out the form with the following attributes:$/) do |table|
	puts table.rows_hash
    criteria = table.rows_hash.each do |field, value|
		fill_in field, :with => value
   end
end

When(/^I click the (.*?) button$/) do |button|
     click_button button
end



