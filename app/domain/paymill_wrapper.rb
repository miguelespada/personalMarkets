class PaymillWrapper

  def self.create_transaction email, paymill_price, buy_params
    p buy_params
    client = PaymillClientFactory.find_or_create_client email, buy_params[:name]
    payment = Paymill::Payment.create token: buy_params[:token], client: client.client_id
    transaction = Paymill::Transaction.create amount: paymill_price, currency: "EUR", client: client.client_id, payment: payment.id, description: "transaction for #{email}"
    transaction
  end

  def self.create_subscription email, subscription_params
    client = PaymillClientFactory.find_or_create_client email, subscription_params["name"]
    client_id = client.client_id
    payment = Paymill::Payment.create token: subscription_params["paymill_card_token"], client: client_id
    subscription = Paymill::Subscription.create(offer: SubscriptionOffer.offer, client: client_id, payment: payment.id)
    subscription
  end

end