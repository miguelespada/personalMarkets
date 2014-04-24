require 'spec_helper'

describe UsersController do
  let(:valid_session) { {} }
  let(:user) { create(:user) } 
  let(:admin) { create(:user, :admin) } 
  let(:second_user) { create(:user) } 
  let(:market) { create(:market)}
  let(:second_market) { create(:market)}


  describe "GET 'index'" do
    it "renders the index template" do
      get :index, valid_session
      expect(response).to render_template(:index)
    end
  end

  describe "User likes a market" do
    it "render index" do
      get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
      expect(response).to render_template(:show)
    end

    it "adds the market to user 'likes'" do
        get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        assigns(:user).favorites.count.should eq 1
        assigns(:user).favorites.include?(market).should eq true
    end

    it "adds the user to the market favorited list" do
        market.favorited.count.should eq 0
        get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 1
        market.favorited.include?(assigns(:user)).should eq true
    end
  end

  describe "User unlikes a market" do
    it "removes the market from user 'likes'" do
      market.favorited.count.should eq 0
      get :unlike,{ user_id: user.to_param, market_id: market.to_param}, valid_session
      market.reload
      market.favorited.count.should eq 0
      market.favorited.include?(assigns(:user)).should eq false
    end
  end

  describe "After a like" do
    before :each do
      user.like(market)
    end
    it "is not possible to a market twice" do
      user.favorites.count.should eq 1
      get :like,{ user_id: user.to_param, market_id: market.to_param}, valid_session
      assigns(:user).favorites.count.should eq 1
      assigns(:user).favorites.include?(market).should eq true
    end

    it "is possible to unlike the market" do
      user.favorites.count.should eq 1
      get :unlike,{ user_id: user.to_param, market_id: market.to_param}, valid_session
      assigns(:user).favorites.count.should eq 0
      assigns(:user).favorites.include?(market).should eq false
    end

    it "a market can be unliked" do
      market.favorited.count.should eq 1
      get :unlike,{ user_id: user.to_param, market_id: market.to_param}, valid_session
      market.reload
      market.favorited.count.should eq 0
      market.favorited.include?(assigns(:user)).should eq false
    end

    it "is possible to like more markets" do
      user.favorites.count.should eq 1
      get :like,{ user_id: user.to_param, market_id: second_market.to_param}, valid_session
      assigns(:user).favorites.count.should eq 2
      assigns(:user).favorites.include?(market).should eq true
      assigns(:user).favorites.include?(second_market).should eq true
    end

    it "a market can get more likes" do
      market.favorited.count.should eq 1
      get :like,{ user_id: second_user.to_param, market_id: market.to_param}, valid_session
      market.reload
      market.favorited.count.should eq 2
      market.favorited.include?(assigns(:user)).should eq true
    end
  end

  describe "PUT /desactivate" do

    before do
      UsersDomain.stub(:desactivate)
    end

    it "redirects back to the users list" do
      put :desactivate, {id: user.to_param}, valid_session
      expect(response).to redirect_to(users_path)
    end

    it "updates the users status to inactive" do
      UsersDomain.should_receive(:desactivate).with(user.to_param)
      
      put :desactivate, {id: user.to_param}, valid_session
    end
  end

end
