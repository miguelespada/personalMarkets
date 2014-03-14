require 'spec_helper'

describe UsersController do
	
 let(:valid_session) { {} }
 let(:user) { FactoryGirl.create(:user) } 
 let(:market) { FactoryGirl.create(:market)}

 it "renders the index template" do
      get :index, valid_session
      expect(response).to render_template("index")
 end

  describe "favorite" do
   it "render index" do
        get :favorite,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        expect(response).to render_template("show")
   end

   it "user likes market" do
        get :favorite,{ user_id: user.to_param, market_id: market.to_param, :v => 1}, valid_session
        assigns(:user).favorites.count.should eq 1
        assigns(:user).favorites.include?(market).should eq true
   end

   it "market gets a like" do
        market.favorited.count.should eq 0
        get :favorite,{ user_id: user.to_param, market_id: market.to_param, :v => 1}, valid_session
        market.reload
        market.favorited.count.should eq 1
        market.favorited.include?(assigns(:user)).should eq true
   end
   
   describe "unlike" do
      before :each do
        user.like(market, 1)
      end
      it "user unlikes market" do
        user.favorites.count.should eq 1
        get :favorite,{ user_id: user.to_param, market_id: market.to_param, :v => 0}, valid_session
        assigns(:user).favorites.count.should eq 0
        assigns(:user).favorites.include?(market).should eq false
      end

     it "market gets unlike" do
          market.favorited.count.should eq 1
          get :favorite,{ user_id: user.to_param, market_id: market.to_param, :v => 0}, valid_session
          market.reload
          market.favorited.count.should eq 0
          market.favorited.include?(assigns(:user)).should eq false
     end
  end

 end
end
