require 'spec_helper'

describe UsersController do
	
 let(:valid_session) { {} }
 let(:user) { FactoryGirl.create(:user) } 
 let(:second_user) { FactoryGirl.create(:user) } 
 let(:market) { FactoryGirl.create(:market)}
 let(:second_market) { FactoryGirl.create(:market)}

  it "renders the index template" do
    get :index, valid_session
    expect(response).to render_template(:index)
  end

  describe "Like" do
   
   it "render index" do
    get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
    expect(response).to render_template(:show)
   end

   it "user likes market" do
        get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        assigns(:user).favorites.count.should eq 1
        assigns(:user).favorites.include?(market).should eq true
   end

   it "market gets a like" do
        market.favorited.count.should eq 0
        get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 1
        market.favorited.include?(assigns(:user)).should eq true
   end

   it "user unlikes a market" do
        market.favorited.count.should eq 0
        get :unlike,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 0
        market.favorited.include?(assigns(:user)).should eq false
   end

   describe "After a like" do
      before :each do
        user.like(market)
      end
      it "user likes market twice" do
        user.favorites.count.should eq 1
        get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        assigns(:user).favorites.count.should eq 1
        assigns(:user).favorites.include?(market).should eq true
      end

      it "user unlikes market" do
        user.favorites.count.should eq 1
        get :unlike,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        assigns(:user).favorites.count.should eq 0
        assigns(:user).favorites.include?(market).should eq false
      end

     it "market gets unlike" do
          market.favorited.count.should eq 1
          get :unlike,{ user_id: user.to_param, market_id: market.to_param}, valid_session
          market.reload
          market.favorited.count.should eq 0
          market.favorited.include?(assigns(:user)).should eq false
     end

     it "user likes two markets" do
          user.favorites.count.should eq 1
          get :like,{ user_id: user.to_param, market_id: second_market.to_param}, valid_session
          assigns(:user).favorites.count.should eq 2
          assigns(:user).favorites.include?(market).should eq true
          assigns(:user).favorites.include?(second_market).should eq true
     end

     it "market gets two likes" do
          market.favorited.count.should eq 1
          get :like,{ user_id: second_user.to_param, market_id: market.to_param}, valid_session
          market.reload
          market.favorited.count.should eq 2
          market.favorited.include?(assigns(:user)).should eq true
     end
  end

 end
end
