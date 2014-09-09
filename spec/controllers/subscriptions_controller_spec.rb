require 'spec_helper'

describe SubscriptionsController do

  let(:user) { create(:user) }
  let(:subscription_params) { {
      "paymill_card_token" => "a_token",
      "price" => "3",
      "quantity" => "5",
      "name" => "juan sanchez"
      }
    }
  let(:domain) { double }

  before do
    sign_in user
    stub_const("SubscriptionDomain", domain)
  end
  
  it "redirects to user profile page on success" do
    domain.should_receive(:subscribe)

    post :create, subscription_params, {}
    expect(response).to redirect_to(user_dashboard_path user)
  end

end
