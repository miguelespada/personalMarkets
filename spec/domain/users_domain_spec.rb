require 'users_domain'

describe "UsersDomain" do

  let(:user) { double }

  before do
    user_repo = double
    stub_const("::User", user_repo)
    user_repo.stub(find: user)
  end

  it ".desactivate" do
    user.should_receive(:desactivate)
    UsersDomain.desactivate("user_id")
  end

  it ".activate" do
    user.should_receive(:activate)
    UsersDomain.activate("user_id")
  end

  it ".update_role" do
    user.should_receive(:update_role).with("admin")
    UsersDomain.update_role("user_id", "admin")
  end
end