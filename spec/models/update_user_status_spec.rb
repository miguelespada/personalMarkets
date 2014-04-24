require 'spec_helper'

describe "Update user status" do
  it "updates the status to active" do
    user = create(:user, :status => "inactive")

    user.update_status "active"
    user.reload
    expect(user.status).to eq("active")
  end
end