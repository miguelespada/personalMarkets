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

   it "adds like" do
        get :favorite,{ user_id: user.to_param, market_id: market.to_param, v: true}, valid_session
        change(user.favorites, :count).by(1)
        change(market.favorited, :count).by(1)
   end

   it "remove like" do
        get :favorite,{ user_id: user.to_param, market_id: market.to_param, v: false}, valid_session
        change(user.favorites, :count).by(-1)
        change(market.favorited, :count).by(-1)
   end
 end
end
