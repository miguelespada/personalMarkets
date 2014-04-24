require 'spec_helper'

describe "Activate a user" do
  it "updates the status to active" do
    user = create(:user, :status => "inactive")

    user.activate
    user.reload
    expect(user.status).to eq("active")
  end
end