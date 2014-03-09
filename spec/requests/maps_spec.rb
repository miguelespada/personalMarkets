require 'spec_helper'

  describe "check maps" do
    it "Js working",  :js => true do
      visit "/"
      page.should have_content("Brooklyn")
    end
  end