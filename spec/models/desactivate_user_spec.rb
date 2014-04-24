require 'spec_helper'

describe "Desactivation a user" do
  it "updates the status to inactive" do
    user = create(:user)

    user.desactivate
    user.reload
    expect(user.status).to eq("inactive")
  end
end