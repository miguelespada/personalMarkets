require 'rspec'

require 'accounting_domain'

describe AccountingDomain do

  let(:user_id) { "an_id" }

  describe ".for_user" do

    Payback = Struct.new(:amount)
    Earning = Struct.new(:amount)

    let(:earnings) { [ Earning.new(10.5), Earning.new(5.1) ] }
    let(:earning_repo) { double(for_user: earnings) }
    let(:paybacks) { [ Payback.new(6.5) ] }
    let(:payback_repo) { double(for_user: paybacks) }

    before(:each) do
      stub_const("Earning", earning_repo)
      stub_const("Payback", payback_repo)
    end

    it "retrieves the accounting for the user" do
      accounting = AccountingDomain.for_user user_id
      expect(accounting.earnings).to eq 15.6
      expect(accounting.paybacks).to eq 6.5
    end
    
  end

  describe ".pay" do

    let(:amount) { 10.5 }
    let(:payback_repo) { double }
    let(:user) { double(id: user_id) }
    
    before(:each) do
      stub_const("Payback", payback_repo)
      stub_const("User", double(find: user))
    end

    it "stores a payback for the user" do
      payback_repo.should_receive(:create).with({user: user, amount: amount})
      AccountingDomain.pay user_id, amount
    end

  end
  
end