require 'rspec'

require 'market_visitor'

describe MarketVisitor do

  describe ".email" do
    it "retrieves 'guest' if no user" do
      expect(MarketVisitor.new(nil).email).to eq "guest"
    end
    it "retrieves user email if user" do
      user = Object.new
      def user.email
        "pedrete@bla.es"
      end
      expect(MarketVisitor.new(user).email).to eq "pedrete@bla.es"
    end
  end
  
  describe ".owns" do
    it "retrieves false if no user" do
      market = Object.new
      expect(MarketVisitor.new(nil).owns(market)).to be_false
    end
    it "retrieves user ownership" do
      market = double
      user = double(:user)
      user.should_receive(:owns).with(market)
      MarketVisitor.new(user).owns(market)
    end
  end
  
end