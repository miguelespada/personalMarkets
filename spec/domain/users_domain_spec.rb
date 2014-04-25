require 'users_domain'

describe "UsersDomain" do

  let(:user) { double }

  before do
    user_repo = double
    stub_const("::User", user_repo)
    user_repo.stub(find: user)
  end

  it ".update_role" do
    user.should_receive(:update_role).with("admin")
    UsersDomain.update_role("user_id", "admin")
  end

  it ".update_status" do
    user.should_receive(:update_status).with("inactive")
    UsersDomain.update_status("user_id", "inactive")
  end
end