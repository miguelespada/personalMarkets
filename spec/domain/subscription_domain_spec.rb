require 'subscription_domain'
require 'subscription_offer'


describe SubscriptionDomain do
  let(:email) { "juan@pm.es" }
  let(:user) { double(email: email, id: "user_id") }
  let(:paymill_wrapper) { double }
  let(:users_domain) { double }
  
  before do
    SubscriptionOffer.offer = "una_offer"
    stub_const("PaymillWrapper", paymill_wrapper)
    stub_const("UsersDomain", users_domain)
  end

  describe ".subscribe" do


    let(:payment) { double }
    let(:subscription) { double(id: 'subscription_id') }
    let(:subscription_payment) { double(payment: payment) }
    let(:subscription_repo) { double(create!: nil) }

    before(:each) do
      stub_const("Subscription", subscription_repo)
    end

    it "creates the paymill subscription" do
      paymill_wrapper.should_receive(:create_subscription).with(email, payment).and_return(subscription)
      users_domain.should_receive(:update_role)
      
      SubscriptionDomain.subscribe user, subscription_payment
    end

    it "updates user role to premium" do
      paymill_wrapper.should_receive(:create_subscription).and_return(subscription)
      users_domain.should_receive(:update_role).with("user_id", "premium")

      SubscriptionDomain.subscribe user, subscription_payment
    end

  end


  describe ".unsubscribe" do

    it "cancels the paymill subscription" do
      paymill_wrapper.should_receive(:cancel_subscription).with(email)
      users_domain.should_receive(:update_role).with("user_id", "normal")

      SubscriptionDomain.unsubscribe user
    end

    it "updates user role to normal" do
      paymill_wrapper.should_receive(:cancel_subscription)
      users_domain.should_receive(:update_role).with("user_id", "normal")
      
      SubscriptionDomain.unsubscribe user
    end
    
  end
end