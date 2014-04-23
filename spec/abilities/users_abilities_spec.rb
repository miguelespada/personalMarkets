require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:other_user){ create(:user) }
    
    context "owner " do
      let(:user){ create(:user)}
      it{ should be_able_to(:manage, Wish.new(:user => user)) }
    end

    context "unauthorized " do
      let(:user){ create(:user)}
      it{ should_not be_able_to(:manage, Wish.new(:user => other_user)) }
    end

    context "admin " do
      let(:user){ create(:user, :admin)}
      it{ should be_able_to(:manage, Wish) }
    end
  end
end