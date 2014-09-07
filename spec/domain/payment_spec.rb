require 'rspec'

require 'payment'

describe Payment do

  describe ".for" do
    it "creates payment with params" do
      payment = Payment.for({:name => "Victor", :token => "a_token", :price => "3", :quantity => "2"})
      expect(payment.price).to eq "3"
      expect(payment.token).to eql "a_token"
    end
  end
  
end