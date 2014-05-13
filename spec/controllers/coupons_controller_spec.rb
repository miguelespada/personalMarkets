require 'spec_helper'

describe CouponsController do
  let(:valid_session) { {} }
  let(:market) { create(:market) } 
  let(:coupon) { create(:coupon, market: market) } 
  let(:user) { create(:user) }  
  let(:second_user) { create(:user) } 
  let(:admin) { create(:user, :admin) } 
  let(:paymill_wrapper) { double }
  let(:token) { "card_token" }
  let(:name) { "Alejandro Bayo" }
  let(:buy_params) { { name: name, token: token } } 

  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :buy, Coupon
      controller.stub(:current_user).and_return(user)
    end

    describe "Buy 'coupon'" do

      before do
        stub_const("PaymillWrapper", paymill_wrapper)
      end

      context 'with right params' do

        before do
          paymill_wrapper.should_receive(:create_transaction).and_return(double(id: "transaction_id"))
        end
        
        it "creates a transaction" do
          CouponTransaction.count.should eq 0
          post "buy", {id: coupon.to_param, buy_params: buy_params, quantity: 1}, valid_session
          CouponTransaction.count.should eq 1
        end

        it "decreases the number of available coupons" do
          post "buy", {id: coupon.to_param, buy_params: buy_params, quantity: 2}, valid_session
          assigns(:coupon).available.should eq 3
          CouponTransaction.count.should eq 1
        end

        it "creates a correct transaction" do
          post "buy", {
            id: coupon.to_param, 
            buy_params: buy_params, 
            quantity: 2
            }, valid_session
          CouponTransaction.first().number.should eq 2
          CouponTransaction.first().user.should eq user
          CouponTransaction.first().coupon.should eq coupon
        end

      end

      context 'with wrong params' do
        
        it "is not allowed to buy zero coupons" do
          post "buy", {id: coupon.to_param, paymill_card_token: token, number: 0}, valid_session
          expect(response.response_code).to eq 401
          CouponTransaction.count.should eq 0
        end

        it "is not allowed to buy negative coupons" do
          post "buy", {id: coupon.to_param, paymill_card_token: token, number: -1}, valid_session
          expect(response.response_code).to eq 401
          CouponTransaction.count.should eq 0
        end

        it "is not allowed to buy more than available" do
          post "buy", {id: coupon.to_param, paymill_card_token: token, number: 20}, valid_session
          expect(response.response_code).to eq 401
          CouponTransaction.count.should eq 0
        end

      end

    end

  end

  context "list coupons and transactions" do 
    let(:market_owner) { create(:user) }  
    let(:user_market) { create(:market, user: market_owner) } 
    let(:second_coupon) { create(:coupon, market: market) }

    describe "Index" do
      it "return the list of coupons" do
        get :index, valid_session
        assigns(:coupons).count eq 2
      end
    end

    describe "Show 'coupon'" do
      let(:market_owner) { create(:user) }  
      let(:user_market) { create(:market, user: market_owner) } 

      it "return success" do
        get :index, {id: user_market.coupon.to_param}, valid_session        
        expect(response.response_code).to eq 200
      end
    end

    describe "list of sold transactions" do
      before(:each) do
        create(:couponTransaction, user: user, coupon: user_market.coupon) 
      end

      it "is allowed for market owner" do
        sign_in :user, market_owner
        get :sold_coupons_by_market, {market_id: user_market.to_param}, valid_session
        expect(response.response_code).to eq 200
        expect(assigns(:transactions).count).to eq 1

      end
      it "it is not allowed for guest" do
        get :sold_coupons_by_market, {market_id: user_market.to_param}, valid_session
        expect(response.response_code).to eq 403
      end
      it "it is not allowed for other users" do
        sign_in :user, user
        get :sold_coupons_by_market, {market_id: user_market.to_param}, valid_session
        expect(response.response_code).to eq 403
      end
    end


    describe "list of bought coupons" do
      before(:each) do
        create(:couponTransaction, user: user, coupon:  user_market.coupon.to_param) 
        create(:couponTransaction, user: market_owner, coupon: second_coupon)
      end
      it "is allowed for market owner" do
        sign_in :user, user
        get :bought_coupons_by_user, {user_id: user.id}, valid_session
        expect(response.response_code).to eq 200
        expect(assigns(:transactions).count).to eq 1
      end
      it "it is not allowed for guest" do
        get :bought_coupons_by_user, {user_id: user.id}, valid_session
        expect(response.response_code).to eq 403
      end
      it "it is not allowed for other users" do
        sign_in :user, user
        get :bought_coupons_by_user, {user_id: market_owner.id}, valid_session
        expect(response.response_code).to eq 403
      end
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
      post "buy", {id: coupon.to_param, paymill_card_token: token, number: 1}, valid_session
      expect(response.response_code).to eq 403
      CouponTransaction.count.should eq 0
    end
  end


end
