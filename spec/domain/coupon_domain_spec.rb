require 'coupon_domain'

describe CouponDomain do
  describe "buy" do
     
    let(:paymill_wrapper) { double }
    let(:email) { "dummy@gmail.com" }  
    let(:user) { double(email: email) } 
    let(:amount) { 2 } 
    let(:coupon) { double(check_buy: true) } 
    let(:paymill_transaction) { double(id: "a_transaction_id") }
    let(:token) { "paymill_card_token" }

    before do
      stub_const("PaymillWrapper", paymill_wrapper)
      paymill_wrapper.should_receive(:create_transaction).and_return(paymill_transaction)
    end

    it "creates a paymill transaction" do
      coupon.should_receive(:buy!)
      CouponDomain.buy coupon, user, amount, token
    end

    it "calls buy on coupon with the paymill transaction" do
      coupon.should_receive(:buy!).with(user, amount, "a_transaction_id")
      CouponDomain.buy coupon, user, amount, token
    end
  end
end