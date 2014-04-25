class SubscriptionsController < ApplicationController

  def create
    SubscriptionDomain.subscribe current_user.email, subscription_params
    UsersDomain.update_role current_user.id, "premium"
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

end
