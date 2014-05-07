require 'spec_helper'

describe "Coupon" do

  describe ".buy!" do

    let(:user) { create(:user) }
    let(:coupon) { create(:coupon, :market => create(:market)) }
    let(:paymill_transaction_id) { "paymill_transaction_id" }
    
    context 'with right params' do

      before(:each) do
        coupon.buy! user, 2, paymill_transaction_id
      end

      it "decreases the number of available coupons" do
        coupon.available.should eq 3
      end

      it "creates a correct transaction" do
        CouponTransaction.first().number.should eq 2
        CouponTransaction.first().user.should eq user
        CouponTransaction.first().coupon.should eq coupon
      end

    end

    context 'with wrong params' do

      after(:each) do
        CouponTransaction.count.should eq 0
      end
      
      it "is not allowed to buy zero coupons" do
        expect { coupon.buy! user, 0, paymill_transaction_id }.to raise_error(ArgumentError)
      end

      it "is not allowed to buy negative coupons" do
        expect { coupon.buy! user, -1, paymill_transaction_id }.to raise_error(ArgumentError)
      end

      it "is not allowed to buy more than available" do
        expect { coupon.buy! user, 20, paymill_transaction_id }.to raise_error(ArgumentError)
      end

    end

  end
  
end