require 'spec_helper'

describe CouponsController do
  let(:valid_session) { {} }
  let(:market) { create(:market) } 
  let(:coupon) { create(:coupon, market: market) } 
  let(:user) { create(:user) }  
  let(:second_user) { create(:user) } 
  let(:admin) { create(:user, :admin) } 

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

  describe "Index 'coupons'" do
    let(:market_owner) { create(:user) }  
    let(:user_market) { create(:market, user: market_owner) } 
    let(:first_coupon) { create(:coupon, market: user_market) } 
    let(:second_coupon) { create(:coupon, market: market) }

    it "is not allowed for guests user" do
      get :index, valid_session
      expect(response.response_code).to eq 401
    end
    it "is not allowed for registered user" do
      sign_in :user, user
      get :index, valid_session
      expect(response.response_code).to eq 401
    end
    it "is allowed for admin" do
      sign_in :user, admin
      get :index, valid_session
      expect(response.response_code).to eq 200
    end
    context "with transactions" do
      before(:each) do
        create(:couponTransaction, user: user, coupon: first_coupon) 
        create(:couponTransaction, user: admin, coupon: second_coupon)
      end
      it "shows all coupons when logged as admin" do
        CouponTransaction.all.count.should eq 2
        sign_in :user, admin
        get :index, valid_session
        expect(assigns(:coupons).count).to eq 2
      end
    end
  end
  
  describe "List outgoing coupon transactions" do
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

      it "does not mix incoming with outgoing transactions" do
        sign_in :user, admin
        get :in_transactions, { user_id: user.to_param }, valid_session
        expect(assigns(:transactions).count).to eq 0
      end

    end
  end
end