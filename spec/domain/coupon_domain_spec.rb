require 'coupon_domain'


describe CouponDomain do
  describe "buy" do
     
    let(:paymill_wrapper) { double }
    let(:email) { "dummy@gmail.com" }  
    let(:user) { double(email: email) } 
    let(:amount) { 10 } 
    let(:coupon) { double } 

    before do
      stub_const("PaymillWrapper", paymill_wrapper)
    end

     it "creates a paymill transaction" do
       paymill_wrapper.should_receive(:create_transaction).with(email, amount)
       coupon.should_receive(:buy!)
       CouponDomain.buy coupon, user, amount
     end
    
  end
end