Given(/^It has comments$/) do
  @comment = create(:comment, :market => @market)
  @market.comments << @comment
end

When(/^I visit the market page$/) do
  visit market_path @market
end

Then(/^I should see the market comments$/) do
  expect(page).to have_content @comment.body
end

When(/^I post a comment$/) do
  fill_in "Body", with: "My market comment"
  click_button "Post comment"
end

Then(/^It appears in the list$/) do
  step "I visit the market page"
  expect(page).to have_content "My market comment"
end

Given(/^Another user has a market$/) do
  @other_user = create(:user)
  @other_market = create(:market, :user => @other_user)
  @other_user.markets << @other_market
end

When(/^I comment other user market$/) do
  step 'Another user has a market'
  step 'I visit the other market page'
  fill_in "Body", with: "Commenting other user market"
  click_button "Post comment"
end

When(/^I visit the other market page$/) do
  visit market_path @other_market
end

Then(/^It appears in the other market list$/) do
  step 'I visit the other market page'
  expect(page).to have_content "Commenting other user market"
end

Then(/^I cant post a comment$/) do
  expect(page).to_not have_css "market-comment-form"
end

Given(/^I post a comment into a market$/) do
  step 'Another user has a market'
  step 'I visit the other market page'
  fill_in "Body", with: "Commenting other user market"
  click_button "Post comment"
end

Then(/^I can delete my comment$/) do
  step 'I visit the other market page'
  within(:css, ".market-comments") do
    expect(page).to have_link "Delete"
  end
end

When(/^I delete my comment$/) do
  step 'I visit the other market page'
  within(:css, ".market-comments") do
    click_link "Delete"
  end
end

Then(/^It disappears from list$/) do
  step 'I visit the other market page'
  expect(page).to_not have_content "Commenting other user market"
end

Then(/^I can delete comments$/) do
  within(:css, ".market-comments") do
    expect(page).to have_link "Delete"
  end
end

Then(/^I cant delete the comment$/) do
  within(:css, ".market-comments") do
    expect(page).to_not have_link "Delete"
  end
end

Then(/^I can edit my comment$/) do
  step 'I visit the other market page'
  within(:css, ".market-comments") do
    expect(page).to have_link "Edit"
  end
end

When(/^I edit my comment$/) do
  step 'I visit the other market page'
  within(:css, ".market-comments") do
    click_link "Edit"
    fill_in "edit_comment_body", with: "updated comment"
    click_button "Save"
  end
end

Then(/^It is updated in the list$/) do
  step 'I visit the other market page'
  expect(page).to have_content "updated comment"
end

Then(/^I cant edit the comment$/) do
  within(:css, ".market-comments") do
    expect(page).to_not have_link "Edit"
  end
end

When(/^I report a comment as abusive$/) do
  visit market_path @market
  within(:css, ".market-comments") do
    expect(page).to have_link "Report"
  end
  click_link "Report"
end

Then(/^The comment is marked as abusive$/) do
  @comment = Comment.find(@comment.id)
  expect(@comment.state).to eq "reported"
end

