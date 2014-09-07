require 'spec_helper'

describe "Updating user role" do

  let(:normal_user) { create(:user, :normal) }
  it "updates the user role to admin" do
    normal_user.update_role("admin")
    normal_user.reload
    expect(normal_user.has_role? "admin").to be_true
    expect(normal_user.role).to eq("admin")
  end

  describe "#available_roles" do
    it "does not include current role" do
      expect(normal_user.available_roles).to_not include("normal")
    end

    it "includes the other roles" do
      expect(normal_user.available_roles).to include("admin")
    end
  end
end