require 'subscription_domain'
require 'subscription_offer'


describe SubscriptionDomain do
  describe ".subscribe" do
    let(:email) { "juan@pm.es" }
    let(:subscription_params) { 
      {
        "name" => "juan sanchez",
        "card_number" => "411111111111",
        "expiration_month" => "03",
        "expiration_year" => "22",
        "cvc" => "222",
        "paymill_card_token" => "the_paymill_card_token"
      }
    }
    let(:client) { double(id: "client_id", client_id: "client_id") }
    let(:client_creator) { double }
    let(:payment_creator) { double }
    let(:payment) { double(id: "payment_id") }
    let(:paymill_client) { double }

    before do
      SubscriptionOffer.offer = "una_offer"
      stub_const("Paymill::Client", client_creator)
      stub_const("Paymill::Payment", payment_creator)
      stub_const("PaymillClient", paymill_client)
    end

    it "creates the paymill payment" do
      paymill_client.should_receive(:find_by_email).and_return nil
      client_creator.should_receive(:create).and_return(client)
      paymill_client.should_receive(:create!)
      paymill_client.should_receive(:find_by_email).and_return(client)

      payment_creator.should_receive(:create).with(token: subscription_params["paymill_card_token"], client: client.id).and_return(payment)

      subscription_creator = double
      stub_const("Paymill::Subscription", subscription_creator)
      subscription_creator.should_receive(:create).with(offer: "una_offer", client: client.id, payment: payment.id)
      SubscriptionDomain.subscribe email, subscription_params
    end

  end
end