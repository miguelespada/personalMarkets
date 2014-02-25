require 'spec_helper'

describe "Update market" do
    it "Update market with featured photo",  :js => true do
    	@market = FactoryGirl.create(:market_with_photo)
    	Market.stub(:find).and_return(@market)
  		visit market_path(@market)
		click_on "Update Market"
		page.should have_content("Featured photo successfully updated!")
    end

    it "Update market remove photo",  :js => true do
      @market = FactoryGirl.create(:market_with_photo)
      Market.stub(:find).and_return(@market)
      @market.stub(:featured).and_return(nil)
      visit market_path(@market)
      click_on "Update Market"
      page.should have_content("Featured photo was removed!")
    end
  end