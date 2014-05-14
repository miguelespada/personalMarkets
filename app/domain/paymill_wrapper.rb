class PaymillWrapper

  def self.create_transaction email, payment
    client = PaymillClientFactory.find_or_create_client email, "paymill client for #{email}"
    paymill_payment = Paymill::Payment.create token: payment.token, client: client.client_id
    transaction = Paymill::Transaction.create amount: payment.total_price, currency: "EUR", client: client.client_id, payment: paymill_payment.id, description: "transaction for #{email}"
    transaction
  end

  def self.create_subscription email, payment
    client = PaymillClientFactory.find_or_create_client email, "paymill client for #{email}"
    client_id = client.client_id
    paymill_payment = Paymill::Payment.create token: payment.token, client: client_id
    subscription = Paymill::Subscription.create(offer: SubscriptionOffer.offer, client: client_id, payment: paymill_payment.id)
    subscription
  end

end