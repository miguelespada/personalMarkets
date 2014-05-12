require 'spec_helper'
require "cancan/matchers"

describe "User" do      
  
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:other_user){ create(:user) }
  
    context "owner" do
      let(:user){ create(:user)}
      it{ should be_able_to(:manage, Wish.new(:user => user)) }
      it{ should be_able_to(:manage, Bargain.new(:user => user)) }
      it{ should be_able_to(:buy, Coupon.new) }
      it{ should be_able_to(:list_user_transactions, user) }
      it{ should be_able_to(:list_market_transactions, Market.new(:user => user)) }
      it{ should be_able_to(:manage, Market.new(:user => user, :featured => Photo.new).featured) }
    end

    context "unauthorized" do
      let(:user){ create(:user)}
      it{ should_not be_able_to(:manage, Wish.new(:user => other_user)) }
      it{ should_not be_able_to(:manage, Bargain.new(:user => other_user)) }
      it{ should_not be_able_to(:manage, Category) }
      it{ should_not be_able_to(:manage, SpecialLocation) }
      it{ should_not be_able_to(:list_user_transactions, other_user) }
      it{ should_not be_able_to(:list_market_transactions, Market.new(:user => other_user)) }
      it{ should_not be_able_to(:manage, Market.new(:user => other_user, :featured => Photo.new).featured) }
    end

    context "admin" do
      let(:user){ create(:user, :admin)}
      it{ should be_able_to(:manage, Wish) }
      it{ should be_able_to(:manage, Bargain) }
      it{ should be_able_to(:buy, Coupon.new) }
      it{ should be_able_to(:manage, Category) }
      it{ should be_able_to(:manage, SpecialLocation) }
      it{ should be_able_to(:list_user_transactions, user) }
      it{ should be_able_to(:list_market_transactions, Market.new) }
      it{ should be_able_to(:manage, Photo.new) }
    end
  end
end