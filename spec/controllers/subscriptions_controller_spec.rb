require 'spec_helper'

describe SubscriptionsController do

  let(:user) { create(:user) }
  let(:subscription_attrs) { 
    {
      "name" => "juan sanchez",
      "card_number" => "411111111111",
      "expiration_month" => "03",
      "expiration_year" => "22",
      "cvc" => "222"
    }
  }
  let(:subscription_params) { { :subscription => subscription_attrs } }
  let(:domain) { double }

  before do
    sign_in user
    stub_const("SubscriptionDomain", domain)
  end
  
  it "redirects to user profile page on success" do
    domain.should_receive(:subscribe)

    post :create, subscription_params, {}
    expect(response).to redirect_to(user_path user)
  end

  it "calls domain with user email and subscription params" do
    domain.should_receive(:subscribe).with(user.email, subscription_attrs)

    post :create, subscription_params, {}
  end

end
