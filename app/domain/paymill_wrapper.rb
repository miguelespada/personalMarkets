class PaymillWrapper

  def self.create_transaction email, payment

    client = PaymillClientFactory.find_or_create_client email, "paymill client for #{email}"
    paymill_payment = Paymill::Payment.create token: payment.token, client: client.client_id
    transaction = Paymill::Transaction.create amount: payment.paymill_price, currency: "EUR", client: client.client_id, payment: paymill_payment.id, description: payment.description
    transaction
  end

  def self.create_subscription email, payment
    client = PaymillClientFactory.find_or_create_client email, "paymill client for #{email}"
    client_id = client.client_id
    paymill_payment = Paymill::Payment.create token: payment.token, client: client_id
    subscription = Paymill::Subscription.create(offer: PAYMILL_SUBSCRIPTION_OFFER, client: client_id, payment: paymill_payment.id)
    subscription
  end

  def self.cancel_subscription email
    subscription = Subscription.find_by email: email
    Paymill::Subscription.delete subscription.paymill_id
    client =  PaymillClient.find_by({email: email})
    client.delete!
  end

end