require 'spec_helper'

describe StatusController do

  describe "PUT /update" do

    let(:user_id) { "user_id" }

    before do
      UsersDomain.stub(:update_status)
    end

    it "redirects back to the users list" do
      put :update, {user_id: user_id, new_status: "inactive"}
      expect(response).to redirect_to(users_path)
    end

    it "updates the users status to inactive" do
      UsersDomain.should_receive(:update_status).with(user_id, "inactive")
      
      put :update, {user_id: user_id, new_status: "inactive"}
    end
  end


end