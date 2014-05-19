require 'paymill'
require 'users_domain'

class SubscriptionDomain

  def self.subscribe user, subscription_payment
    subscription = PaymillWrapper.create_subscription user.email, subscription_payment.payment
    Subscription.create!(email: user.email, paymill_id: subscription.id)
    UsersDomain.update_role user.id, "premium"
  rescue Paymill::PaymillError => e
    raise SubscriptionDomainException.new e.message
  end

  def self.unsubscribe user
    PaymillWrapper.cancel_subscription user.email
    UsersDomain.update_role user.id, "normal"
  rescue Paymill::PaymillError => e
    raise SubscriptionDomainException.new e.message
  end
end

class SubscriptionDomainException < Exception
end