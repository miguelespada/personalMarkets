Given(/^I am logged in as an admin$/) do
  @admin = FactoryGirl.create(:user, :admin)
  log_in_as @admin
end

Then(/^I can edit the market comments$/) do
  within(:css, ".market-comments") do
    click_link "Edit"
    fill_in "edit_comment_body", with: "updated comment"
    click_button "Save"
  end
  expect(page).to have_content "updated comment"
end

Then(/^I can edit the market$/) do
  within(:css, ".market-actions") do
    expect(page).to have_link "Edit"
  end
end