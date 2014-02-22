Given(/^I am in the app$/) do
  visit '/'
end

When(/^I read the title$/) do
  
end

Then(/^I should see "(.*?)"$/)  do |content|
  page.should have_content content
end
