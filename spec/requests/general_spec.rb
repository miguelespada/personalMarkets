require 'spec_helper'

describe "browse" do  
  it "When I go to my markets I only see my markets"
end

describe "update market" do
  it "CLick on calendar to add a date"
  it "I can add list of tags"
  it "Use map to add location and address to a market"
end

describe "social" do
  it "No self likes allowed"
  it "No self unlikes allowed"
  it "No double likes allowed"
  it "No double likes allowed"
  it "If market is deleted, it is not anymore in my favorites"
end

describe "category" do
  it "I cannot delete the default category"
  it "There is a default category"
end

describe "tags" do
  it "I can see the suggested tag list" do
    visit tags_path
    STARRED_TAGS["tags"].each do |tag|
      page.should have_content( tag )
    end
  end
end