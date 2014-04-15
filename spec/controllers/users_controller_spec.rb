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

  describe "List outcoming coupon transactions" do
    let(:coupon) { create(:coupon, market: market) } 

    it "It is not allowed for guest" do
      get :out_transactions, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 401
    end

    it "It is allow for registered user" do
      sign_in :user, user
      get :out_transactions, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 200
    end

    it "is not allow for other users" do
      sign_in :user, second_user
      get :out_transactions, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 401
    end

    context "without transactions" do
      it "shows user transactions when logged" do
        sign_in :user, user
        get :out_transactions, { user_id: user.to_param }, valid_session
        expect(assigns(:transactions).count).to eq 0
      end
    end

    context "with transactions" do
      before(:each) do
        create(:couponTransaction, user: user, coupon: coupon) 
      end
      it "shows user transactions when logged" do
        sign_in :user, user
        get :out_transactions, { user_id: user.to_param }, valid_session
        expect(assigns(:transactions).count).to eq 1
      end
      it "shows user transactions when logged as admin" do
        sign_in :user, admin
        get :out_transactions, { user_id: user.to_param }, valid_session
        expect(assigns(:transactions).count).to eq 1
      end
    end
  end

  describe "List incoming coupon transactions" do
    let(:coupon) { create(:coupon, market: market) } 

    it "It is not allowed for guest" do
      get :in_transactions, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 401
    end    

    it "It is allowed for admin" do        
      sign_in :user, admin
      get :in_transactions, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 200
    end

    it "It is allowed for registerd user" do        
      sign_in :user, user
      get :in_transactions, { user_id: user.to_param }, valid_session
      expect(response.response_code).to eq 200
    end

    context "with transactions" do
      let(:market_owner) { create(:user) }  
      let(:user_market) { create(:market, user: market_owner) } 
      let(:coupon) { create(:coupon, market: user_market) } 
      let(:user_market_2) { create(:market, user: market_owner) } 
      let(:coupon) { create(:coupon, market: user_market) } 
      let(:coupon_2) { create(:coupon, market: user_market_2) } 
      
      before(:each) do
        create(:couponTransaction, user: user, coupon: coupon) 
        create(:couponTransaction, user: user, coupon: coupon) 
      end
      
      it "shows user incoming transactions" do
        sign_in :user, admin
        get :in_transactions, { user_id: market_owner.to_param }, valid_session
        expect(assigns(:transactions).count).to eq 2
      end

      it "does not mix incoming with outcoming transactions" do
        sign_in :user, admin
        get :in_transactions, { user_id: user.to_param }, valid_session
        expect(assigns(:transactions).count).to eq 0
      end

    end
  end
end
