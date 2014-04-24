require 'markets_domain'
require 'markets_domain_exception'

describe MarketsDomain do

  let(:market_id) { "an_id" }
  let(:user_id) { "an_id" }
  let(:listener) { double :listener }
  let(:market) { double :market }
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
      after do
        @it.create_market(user_id, { :name => "my market", :description => "my market description" })
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

      after do
        @it.publish_market "an_id"
      end

      it "registers success callback if market published successfully" do
        markets_repo.stub(:find) { market }
        market.stub(:publish) { :true }
        listener.should_receive(:publish_succeeded).with(market)
      end

      it "registers fail callback if market not published successfully" do
        markets_repo.stub(:find) { market }
        market.stub(:publish).and_raise(MarketsDomainException)
        listener.should_receive(:publish_failed).with(market_id)
      end
    end
  end

end