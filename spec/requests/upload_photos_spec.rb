require 'spec_helper'

describe "Update market" do
    it "with photo",  :js => true do
    	@market = FactoryGirl.create(:market_with_photo)
    	Market.stub(:find).and_return(@market)
  		visit market_path(@market)
		click_on "Update Market"
		page.should have_content("Featured photo successfully updated!")
    end
    it "without photo",  :js => true do
    	@market = FactoryGirl.create(:market)
    	Market.stub(:find).and_return(@market)
  		visit market_path(@market)
		click_on "Update Market"
		page.should_not have_content("Featured photo successfully updated!")
    end
  end