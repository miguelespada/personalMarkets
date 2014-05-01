require 'spec_helper'
require "cancan/matchers"

describe "User" do      
  
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:other_user){ create(:user) }
  
    context "owner" do
      let(:user){ create(:user)}
      it{ should be_able_to(:manage, Wish.new(:user => user)) }
      it{ should be_able_to(:buy, Coupon.new) }
      it{ should be_able_to(:list_transactions, Coupon.new) }
    end

    context "unauthorized" do
      let(:user){ create(:user)}
      it{ should_not be_able_to(:manage, Wish.new(:user => other_user)) }
      it{ should_not be_able_to(:manage, Category) }
      it{ should_not be_able_to(:manage, SpecialLocation) }
    end

    context "admin" do
      let(:user){ create(:user, :admin)}
      it{ should be_able_to(:manage, Wish) }
      it{ should be_able_to(:buy, Coupon.new) }
      it{ should be_able_to(:list_transactions, Coupon.new) }
      it{ should be_able_to(:manage, Category) }
      it{ should be_able_to(:manage, SpecialLocation) }
    end
  end
end