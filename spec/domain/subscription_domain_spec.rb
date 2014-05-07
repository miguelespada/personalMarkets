require 'subscription_domain'
require 'subscription_offer'


describe SubscriptionDomain do
  describe ".subscribe" do
    let(:email) { "juan@pm.es" }
    let(:user) { double(email: email, id: "user_id") }
    let(:paymill_wrapper) { double }
    let(:users_domain) { double }
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

    before do
      SubscriptionOffer.offer = "una_offer"
      stub_const("PaymillWrapper", paymill_wrapper)
      stub_const("UsersDomain", users_domain)
    end

    it "creates the paymill subscription" do
      paymill_wrapper.should_receive(:create_subscription).with(email, subscription_params)
      users_domain.should_receive(:update_role)
      SubscriptionDomain.subscribe user, subscription_params
    end

    it "updates user role to premium" do
      paymill_wrapper.should_receive(:create_subscription)
      users_domain.should_receive(:update_role).with("user_id", "premium")
      SubscriptionDomain.subscribe user, subscription_params
    end

  end
end