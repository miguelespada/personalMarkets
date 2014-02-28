require 'spec_helper'

describe "Update market" do
    xit "Update featured photo",  :js => true do
    	@market = FactoryGirl.create(:market_with_photo)
    	Market.stub(:find).and_return(@market)
  		visit market_path(@market)
		  click_on "Update Market"
		  page.should have_content("Market successfully updated!")
    end

    describe "nothing change" do
      xit "change name",  :js => true do
        @market = FactoryGirl.create(:market)
        visit market_path(@market)
        click_on "Update Market"
        page.should_not have_content("Market successfully updated!")
      end
    end
  end