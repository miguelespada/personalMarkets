require 'coupon_domain'
require 'coupon_payment'

describe CouponDomain do
  describe "buy" do
     
    let(:paymill_wrapper) { double }
    let(:email) { "dummy@gmail.com" }  
    let(:user) { double(email: email) } 
    let(:amount) { 2 } 
    let(:coupon) { double(check_buy: true, price: 20) } 
    let(:paymill_transaction) { double(id: "a_transaction_id") }
    let(:token) { "paymill_card_token" }
    let(:payment) { double(total_price: amount, token: token, quantity: 2) }
    let(:coupon_payment) { CouponPayment.new coupon, payment }

    before do
      stub_const("PaymillWrapper", paymill_wrapper)
      paymill_wrapper.should_receive(:create_transaction).and_return(paymill_transaction)
    end

    it "creates a paymill transaction" do
      coupon.should_receive(:buy!)
      CouponDomain.buy user, coupon_payment
    end

    it "calls buy on coupon with the paymill transaction" do
      coupon.should_receive(:buy!).with(user, amount, "a_transaction_id")
      CouponDomain.buy user, coupon_payment
    end
  end
end