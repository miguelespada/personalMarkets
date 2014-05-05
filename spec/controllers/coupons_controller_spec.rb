require 'spec_helper'

describe CouponsController do
  let(:valid_session) { {} }
  let(:market) { create(:market) } 
  let(:coupon) { create(:coupon, market: market) } 
  let(:user) { create(:user) }  
  let(:second_user) { create(:user) } 
  let(:admin) { create(:user, :admin) } 

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :buy, Coupon
      controller.stub(:current_user).and_return(user)
    end

    describe "Buy 'coupon'" do
      it "creaes a transacrion" do
        CouponTransaction.count.should eq 0
        post "buy", {id: coupon.to_param, number: 1}, valid_session
        CouponTransaction.count.should eq 1
      end

      it "is not allowed to buy zero coupons" do
        post "buy", {id: coupon.to_param, number: 0}, valid_session
        expect(response.response_code).to eq 401
        CouponTransaction.count.should eq 0
      end

      it "is not allowed to buy negative coupons" do
        post "buy", {id: coupon.to_param, number: -1}, valid_session
        expect(response.response_code).to eq 401
        CouponTransaction.count.should eq 0
      end

      it "is not allowed to buy more than available" do
        post "buy", {id: coupon.to_param, number: 20}, valid_session
        expect(response.response_code).to eq 401
        CouponTransaction.count.should eq 0
      end

      it "decreases the number of available coupons" do
        post "buy", {id: coupon.to_param, number: 2}, valid_session
        assigns(:coupon).available.should eq 3
        CouponTransaction.count.should eq 1
      end

      it "creates a correct transaction" do
        post "buy", {id: coupon.to_param, number: 2}, valid_session
        CouponTransaction.first().number.should eq 2
        CouponTransaction.first().user.should eq user
        CouponTransaction.first().coupon.should eq coupon
      end
    end
  end

  context "with coupon transactions" do 
    let(:market_owner) { create(:user) }  
    let(:user_market) { create(:market, user: market_owner) } 
    let(:first_coupon) { create(:coupon, market: user_market) } 
    let(:second_coupon) { create(:coupon, market: market) }

    describe "Index" do
      it "return the list of coupons" do
        get :index, valid_session
        assigns(:coupons).count eq 2
      end
    end

   describe "List transactions" do
      before(:each) do
        user_market.coupon = first_coupon
        market.coupon = second_coupon
        create(:couponTransaction, user: user, coupon: first_coupon) 
        create(:couponTransaction, user: market_owner, coupon: second_coupon)
      end
      it "shows out transactions 1" do
        sign_in :user, user
        get :list_transactions, {user_id: user.to_param}, valid_session
        expect(assigns(:in_transactions).count).to eq 0
        expect(assigns(:out_transactions).count).to eq 1
      end
      it "shows out transactions 2" do
        sign_in :user, market_owner
        get :list_transactions, {user_id: market_owner.to_param}, valid_session
        expect(assigns(:in_transactions).count).to eq 1
        expect(assigns(:out_transactions).count).to eq 1
      end
    end
  end

  describe "Show 'coupon'" do
    let(:market_owner) { create(:user) }  
    let(:user_market) { create(:market, user: market_owner) } 
    let(:first_coupon) { create(:coupon, market: user_market) } 

    it "return success" do
      get :index, {id: first_coupon.to_param}, valid_session        
      expect(response.response_code).to eq 200
    end
  end

  context "unauthorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.cannot :manage, Wish
      controller.stub(:current_user).and_return(user)
    end
    it "is cannot buy" do
      post "buy", {id: coupon.to_param, number: 1}, valid_session
      expect(response.response_code).to eq 403
      CouponTransaction.count.should eq 0
    end
    it "is cannot list transactions" do
      get :list_transactions, {user_id: user.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end


  describe "transactions"
    xit "list the coupon transactions"
end
