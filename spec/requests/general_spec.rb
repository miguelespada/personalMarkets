require 'spec_helper'

describe "browse" do  
  xit "When I go to my markets I only see my markets"
end

describe "update market" do
  xit "CLick on calendar to add a date"
  xit "I can add list of tags"
  xit "Use map to add location and address to a market"
end

describe "social" do
  xit "No self likes allowed"
  xit "No self unlikes allowed"
  xit "No double likes allowed"
  xit "No double likes allowed"
  xit "If market is deleted, it is not anymore in my favorites"
end

describe "category" do
  xit "I cannot delete the default category"
  xit "There is a default category"
end

describe "tags" do
  it "I can see the suggested tag list" do
    visit tags_path
    STARRED_TAGS["tags"].each do |tag|
      page.should have_content( tag )
    end
  end
end