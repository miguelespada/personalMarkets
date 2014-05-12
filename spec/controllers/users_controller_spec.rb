require 'spec_helper'

describe UsersController do
  let(:valid_session) { {} }
  let(:user) { create(:user) } 
  let(:admin) { create(:user, :admin) } 
  let(:second_user) { create(:user) } 
  let(:market) { create(:market)}
  let(:second_market) { create(:market)}
  let(:presenter) { double }
  let(:presenter_factory) { double(for: presenter) }


  context "authorized user" do 
    before(:each) do
      stub_const("UsersPresenter", presenter_factory)
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :manage, User
      controller.stub(:current_user).and_return(user)
    end

    describe "GET 'index'" do

      it "renders the index template" do
        get :index, valid_session
        expect(response).to render_template(:index)
      end

      it "wraps users in a presenter" do
        get :index, valid_session
        expect(assigns(:users)).to be(presenter)
      end
    end
  end
  
  context "authorized user" do 
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
      @ability.can :like, Market
      controller.stub(:current_user).and_return(user)
    end

    describe "User likes a market" do
      it "render index" do
        get :like, {market_id: market.to_param}, valid_session
        expect(response.response_code).to eq 302  
      end

      it "adds the market to user 'likes'" do
        get :like,{market_id: market.to_param}, valid_session
        user.favorites.count.should eq 1
        user.favorites.include?(market).should eq true
      end

      it "adds the user to the market favorited list" do
        market.favorited.count.should eq 0
        get :like,{ market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 1
        market.favorited.include?(user).should eq true
      end
    end
    describe "User unlikes a market" do
      it "removes the market from user 'likes'" do
        market.favorited.count.should eq 0
        get :unlike,{ market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 0
        market.favorited.include?(user).should eq false
      end
    end
    describe "After a like" do
      before :each do
        user.like(market)
      end
      it "is not possible to a market twice" do
        user.favorites.count.should eq 1
        get :like,{market_id: market.to_param}, valid_session
        user.favorites.count.should eq 1
        user.favorites.include?(market).should eq true
      end

      it "is possible to unlike the market" do
        user.favorites.count.should eq 1
        get :unlike,{ market_id: market.to_param}, valid_session
        user.favorites.count.should eq 0
        user.favorites.include?(market).should eq false
      end

      it "a market can be unliked" do
        market.favorited.count.should eq 1
        get :unlike,{ market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 0
        market.favorited.include?(user).should eq false
      end

      it "is possible to like more markets" do
        user.favorites.count.should eq 1
        get :like,{market_id: second_market.to_param}, valid_session
        user.favorites.count.should eq 2
        user.favorites.include?(market).should eq true
        user.favorites.include?(second_market).should eq true
      end

      it "a market can get more likes" do
        market.favorited.count.should eq 1
        controller.stub(:current_user).and_return(second_user)
        get :like,{market_id: market.to_param}, valid_session
        market.reload
        market.favorited.count.should eq 2
        market.favorited.include?(second_user).should eq true
      end
    end
  end


  context "guest user" do 
    it "cannot like" do
      get :like,{ market_id: market.to_param}, valid_session
      expect(response.response_code).to eq 403
    end

    it "cannot unlike" do
      get :unlike,{ market_id: market.to_param}, valid_session
      expect(response.response_code).to eq 403
    end
  end 
end
