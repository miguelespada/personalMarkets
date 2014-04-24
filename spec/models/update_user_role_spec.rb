require 'spec_helper'

describe "Updating user role" do
  it "updates the user role to admin" do
    user = create(:user, :normal)

    user.update_role("admin")
    user.reload
    expect(user.has_role? "admin").to be_true
    expect(user.role).to eq("admin")
  end
end