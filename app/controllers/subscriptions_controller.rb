class SubscriptionsController < ApplicationController

  def create
    subscription_payment = SubscriptionPayment.new Payment.for payment_params
    SubscriptionDomain.subscribe current_user, subscription_payment
    redirect_to user_path(current_user), notice: "You have become premium successfully."
  rescue SubscriptionDomainException => e
    flash[:error] = "Something went wrong while subscribing (#{e.message})."
    redirect_to user_subscription_path(current_user)
  end

  private

  def subscription_params
    params.require(:subscription).permit(
      :name, :card_number, :expiration_month,
      :expiration_year, :cvc, :paymill_card_token)
  end

  def payment_params
    {
      name: params['name'],
      price: params['price'].to_f,
      quantity: params[:quantity].to_i,
      token: params['paymill_card_token']
    }
  end

end
