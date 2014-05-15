require 'paymill_wrapper'
require 'subscription_offer'

describe PaymillWrapper do

  let(:factory) { double }
  let(:paymill_client) { double(client_id: "client_id") }

  before do
    stub_const("PaymillClientFactory", factory)
    factory.should_receive(:find_or_create_client).and_return(paymill_client)
  end

  describe ".create_subscription" do

    let(:email) { "juan@pm.es" }
    let(:subscription_payment) { double(token: "the_paymill_card_token")}
    let(:payment_creator) { double }
    let(:payment) { double(id: "payment_id") }

    before do
      SubscriptionOffer.offer = "una_offer"
      stub_const("Paymill::Payment", payment_creator)
    end

    it "creates the paymill subscription" do
      payment_creator.should_receive(:create).with(token: subscription_payment.token, client: "client_id").and_return(payment)

      subscription_creator = double
      stub_const("Paymill::Subscription", subscription_creator)
      subscription_creator.should_receive(:create).with(offer: "una_offer", client: "client_id", payment: payment.id)
      PaymillWrapper.create_subscription email, subscription_payment
    end

  end

  describe ".create_transaction" do
    let(:paymill_payment) { double } 
    let(:paymill_transaction) { double } 
    let(:email) { "dummy@gmail.com" }
    let(:amount) { 20 }
    let(:token) { "a_token" } 
    let(:payment) { double(token: token, paymill_price: amount, description: "payment description") }

    before do
      stub_const("Paymill::Payment", paymill_payment)
      stub_const("Paymill::Transaction", paymill_transaction)
      paymill_payment.should_receive(:create).with(token: token, client: "client_id").and_return(double(id: "payment_id"))
    end

    it "searchs a paymill client by the email" do
      paymill_transaction.should_receive(:create)
      PaymillWrapper.create_transaction email, payment
    end

    it "creates a Paymill payment" do
      paymill_transaction.should_receive(:create)
      PaymillWrapper.create_transaction email, payment
    end

    it "creates a Paymill transaction" do
      paymill_transaction.should_receive(:create).with(amount: amount, currency: "EUR", client: "client_id", payment: "payment_id", description: payment.description)
      PaymillWrapper.create_transaction email, payment
    end
  end
  
end