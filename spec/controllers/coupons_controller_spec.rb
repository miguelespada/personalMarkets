require 'spec_helper'

describe CouponsController do
  let(:valid_session) { {} }
  let(:market) { create(:market) } 
  let(:coupon) { create(:coupon, market: market) } 
  let(:user) { create(:user) }  

  describe "Buy 'coupon'" do
    it "is allowed for registered user" do
      sign_in :user, user
      post "buy", {id: coupon.to_param, number: 1}, valid_session
      expect(response.response_code).to eq 302
      CouponTransaction.count.should eq 1
    end

    it "is not allowed for guest user" do
      post "buy", {id: coupon.to_param, number: 1}, valid_session
      expect(response.response_code).to eq 401
      CouponTransaction.count.should eq 0
    end

    it "is not allowed to buy zero coupons" do
      sign_in :user, user
      post "buy", {id: coupon.to_param, number: 0}, valid_session
      expect(response.response_code).to eq 401
      CouponTransaction.count.should eq 0
    end

    it "is not allowed to buy negative coupons" do
      sign_in :user, user
      post "buy", {id: coupon.to_param, number: -1}, valid_session
      expect(response.response_code).to eq 401
      CouponTransaction.count.should eq 0
    end

    it "is not allowed to buy more than available" do
      sign_in :user, user
      post "buy", {id: coupon.to_param, number: 20}, valid_session
      expect(response.response_code).to eq 401
      CouponTransaction.count.should eq 0
    end

    it "decreases the number of available coupons" do
      sign_in :user, user
      post "buy", {id: coupon.to_param, number: 2}, valid_session
      assigns(:coupon).available.should eq 3
      CouponTransaction.count.should eq 1
    end

    it "creates a correct transaction" do
      sign_in :user, user
      post "buy", {id: coupon.to_param, number: 2}, valid_session
      CouponTransaction.first().number.should eq 2
      CouponTransaction.first().user.should eq user
      CouponTransaction.first().coupon.should eq coupon
    end
  end

  describe "Create 'coupon'" do
    let(:market_owner) { create(:user) }  
    let(:user_market) { create(:market, user: market_owner) } 
    let(:coupon_params) { { :market_id => user_market.to_param, 
                            :coupon => 
                            {:description => "My dummy coupon", 
                              :price => "10", 
                              :available => "20" }}}

    it "is not allowed for guest" do
      post :create, coupon_params, valid_session
      expect(response.response_code).to eq 401
    end

    it "is not allowed for other user" do
      sign_in :user, user
      post :create, coupon_params, valid_session
      expect(response.response_code).to eq 401
    end

    it "is allowed for market owner" do
      sign_in :user, market_owner
      post :create, coupon_params, valid_session
      expect(response.response_code).to eq 302
    end

     it "changes the 'has_coupon' property" do
      sign_in :user, market_owner
      user_market.has_coupon?.should eq false
      post :create, coupon_params, valid_session
      user_market.reload
      user_market.has_coupon?.should eq true
    end

    it "is not allowed when there is already a coupon" do
      sign_in :user, market_owner
      Market.any_instance.stub(:has_coupon?).and_return(true)
      post :create, coupon_params, valid_session
      expect(response.response_code).to eq 401
    end
  end

  describe "List transactions" do
    it "is not allowed for guests user" do
      get :index, {}, valid_session
      expect(response.response_code).to eq 401
    end
  end
end
