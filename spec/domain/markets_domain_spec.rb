require 'markets_domain'
require 'markets_domain_exception'

describe MarketsDomain do

  let(:market_id) { "an_id" }
  let(:user_id) { "an_id" }
  let(:listener) { double :listener }
  let(:market) { double(pro?: false, belongs_to_premium_user?: false) }
  let(:market_pro) { double(pro?: true) }
  let(:coupon) { double :coupon }
  let(:markets_repo) { double :markets_repo }
  let(:users_repo) { double :users_repo }
  let(:user) { double :user }

  before do
    @it = described_class.new(listener, markets_repo, users_repo)
  end

  describe "user markets" do
    context 'retrieving user markets' do
      it "calls the success callback with the user markets" do
        user_markets = double("user_markets")
        users_repo.stub(:find)
        markets_repo.stub(:user_markets) { user_markets }
        listener.should_receive(:user_markets_succeeded).with(user_markets)

        @it.user_markets user_id
      end
    end
    it "retrieves user markets" do
    end
  end

  describe "create market" do

    let(:market_params) { { name: "my market", description: "my market description" } } 

    context "without coupon params" do
      after do
        @it.create_market(user_id, market_params)
      end

      it "registers success callback if market created successfully" do
        users_repo.stub(:find) { user }
        user.stub(:add_market) { market }
        market.stub(:save!)
        listener.should_receive(:create_market_succeeded).with(market)
      end

      it "registers fail callback if market not created successfully" do
        users_repo.stub(:find) { user }
        user.stub(:add_market) { market }
        market.stub(:save!).and_raise(MarketsDomainException)
        listener.should_receive(:create_market_failed)
      end
    end
  end

  describe "market actions" do
    describe "archive market" do

      after do
        @it.archive_market "an_id"
      end

      it "registers success callback if market archived successfully" do
        markets_repo.stub(:find) { market }
        market.stub(:archive) { :true }
        listener.should_receive(:archive_succeeded).with(market)
      end

      it "registers fail callback if market not archived successfully" do
        markets_repo.stub(:find) { market }
        market.stub(:archive).and_raise(MarketsDomainException)
        listener.should_receive(:archive_failed).with(market_id)
      end
    end

    describe "publish market" do

      let(:fake_evaluation) { double(valid?: true, could_be_better?: false) }
      let(:fake_evaluator) { double(check_fields: fake_evaluation) }
      let(:market_evaluator) { double(new: fake_evaluator) }

      before do
        market.stub(:has_coupon?) { true }
        stub_const("MarketEvaluator", market_evaluator)
      end

      after do
        @it.publish_market "an_id"
      end

      context 'market with coupon' do
        it "registers publishing not possible because market has coupon and is not pro" do
          markets_repo.stub(:find) { market }
          listener.should_receive(:publish_not_available).with(market, fake_evaluation)
        end

        it "registers publishing not possible because market has coupon and owner is not premium" do
          markets_repo.stub(:find) { market }
          listener.should_receive(:publish_not_available).with(market, fake_evaluation)
        end

        it "registers success callback if market belongs to premium user" do
          market.stub(:belongs_to_premium_user?) { true }
          markets_repo.stub(:find) { market }
          market.stub(:publish) { true }
          listener.should_receive(:publish_succeeded).with(market)
        end

        it "registers success callback if market is pro" do
          market.stub(:pro?) { true }
          markets_repo.stub(:find) { market }
          market.stub(:publish) { true }
          listener.should_receive(:publish_succeeded).with(market)
        end

      end

      context 'market without coupon' do

        before do
          market.stub(:has_coupon?) { false }
        end

        it "registers success callback if market published successfully" do
          markets_repo.stub(:find) { market }
          market.stub(:publish) { true }
          listener.should_receive(:publish_succeeded).with(market)
        end

        it "registers fail callback if market not published successfully" do
          markets_repo.stub(:find) { market }
          market.stub(:publish).and_raise(MarketsDomainException)
          listener.should_receive(:publish_failed).with(market_id)
        end
      end

    end

    describe "make pro" do

      let(:paymill_transaction) { double(id: "a_transaction_id") }
      let(:paymill_wrapper) { double(create_transaction: paymill_transaction) }
      let(:email) { "dummy@gmail.com" }  
      let(:user) { double(email: email) } 
      let(:regular_market) { double(user: user, go_pro: nil) }
      let(:payment) { double }
      let(:market_pro_payment) { double(payment: payment) }

      before do
        markets_repo.stub(:find) { regular_market }
        stub_const("PaymillWrapper", paymill_wrapper)
      end

      it "creates a paymill transaction" do
        paymill_wrapper.should_receive(:create_transaction).
          with(email, market_pro_payment)
        @it.make_pro market_id, market_pro_payment
      end

      it "calls buy on coupon with the paymill transaction" do
        regular_market.should_receive(:go_pro)
        @it.make_pro market_id, market_pro_payment
      end

    end
  end

end