require 'paymill'


class SubscriptionDomain

  def self.subscribe email, subscription_params
    subscription = paymill_subscribe email, subscription_params
  rescue Paymill::PaymillError => e
    raise SubscriptionDomainException.new e.message
  end

  def self.paymill_subscribe email, subscription_params
    client = PaymillClient.find_by_email email
    if client.nil?
      client = Paymill::Client.create email: email, description: subscription_params["name"]
      PaymillClient.create!({email: email, client_id: client.id})
      client = PaymillClient.find_by_email email
    end
    
    client_id = client.client_id
    payment = Paymill::Payment.create token: subscription_params["paymill_card_token"], client: client_id
    subscription = Paymill::Subscription.create(offer: SubscriptionOffer.offer, client: client_id, payment: payment.id)
    subscription
  end

end

class SubscriptionDomainException < Exception
end