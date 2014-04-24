require 'spec_helper'

describe RoleController do

  describe "GET /change" do
    it "assigns the user" do
      user = double
      User.stub(:find).with("user_id") { user }

      get :change, user_id: "user_id"
      expect(assigns(:user)).to be(user)
    end
  end

  describe "PUT /update" do

    let(:user_id) { "user_id" } 

    before do
      UsersDomain.stub(:update_role)
    end

    it "redirects to users" do
      put :update, user_id: user_id
      expect(response).to redirect_to users_path
    end

    it "updates user role to admin" do
      UsersDomain.should_receive(:update_role).with(user_id, "admin")

      put :update, user_id: user_id, new_role: "admin"
    end
  end

end