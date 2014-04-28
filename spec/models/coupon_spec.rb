require 'spec_helper'

describe Coupon do
  describe "buy" do
      let(:coupon_params) { attributes_for(:coupon) }

    it "creates an offer on paymill" do
      paymill_wrapper.should_receive(:create_transaction).with(email: "dummy@gmail.com", amount: 20)
      @it.create_market(user_id, market_with_coupon_params) 
    end
  end
end
