require 'users_domain'

describe "UsersDomain" do
  it ".desactivate" do
    user = double
    stub_const("::User", stub(find: user))
    user.should_receive(:desactivate)
    UsersDomain.desactivate("user_id")
  end

  it ".update_role" do
    user = double
    stub_const("::User", stub(find: user))
    user.should_receive(:update_role).with("admin")
    UsersDomain.update_role("user_id", "admin")
  end
end