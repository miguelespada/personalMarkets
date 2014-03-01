# require 'spec_helper'

# describe "Update market" do
#     xit "Change name",  :js => true do
#     	market = FactoryGirl.create(:market)
#       market.stub(:name).and_return("New name")
#   		visit market_path(market)
# 		  click_on "Update Market"
# 		  page.should have_content("Market successfully updated!")
#     end

#     xdescribe "Nothing changes" do
#       it "Nothing changes", :js => true do
#         market = FactoryGirl.create(:market)
#         visit market_path(market)
#         Market.stub(:find).and_return(market)
#         click_on "Update Market"
#         page.should have_content("Nothing changes!")
#       end
#     end
#   end