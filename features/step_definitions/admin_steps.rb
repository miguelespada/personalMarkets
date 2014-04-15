Then(/^I can edit the market comments$/) do
  within(:css, ".market-comments") do
    click_link "Edit"
    fill_in "edit_comment_body", with: "updated comment"
    click_button "Save"
  end
  expect(page).to have_content "updated comment"
end

