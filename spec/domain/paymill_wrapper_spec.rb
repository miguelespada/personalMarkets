require 'paymill_wrapper'

describe PaymillWrapper do

  describe ".create_transaction" do
    let(:paymill_client) { double } 
    let(:paymill_payment) { double } 
    let(:paymill_transaction) { double } 
    let(:email) { "dummy@gmail.com" }
    let(:amount) { 20 }
    let(:factory) { double }
    let(:token) { "a_token" } 

    before do
      stub_const("PaymillClient", paymill_client)
      stub_const("PaymillClientFactory", factory)
      stub_const("Paymill::Payment", paymill_payment)
      stub_const("Paymill::Transaction", paymill_transaction)
      factory.should_receive(:find_or_create_client).and_return(double(client_id: "client_id"))
      paymill_payment.should_receive(:create).with(token: token, client: "client_id").and_return(double(id: "payment_id"))
    end

    it "searchs a paymill client by the email" do
      paymill_transaction.should_receive(:create)
      PaymillWrapper.create_transaction email, amount, token
    end

    it "creates a Paymill payment" do
      paymill_transaction.should_receive(:create)
      PaymillWrapper.create_transaction email, amount ,token
    end

    it "creates a Paymill transaction" do
      paymill_transaction.should_receive(:create).with(amount: amount, currency: "EUR", client: "client_id", payment: "payment_id", description: "transaction for dummy@gmail.com")
      PaymillWrapper.create_transaction email, amount, token
    end
  end
  
end