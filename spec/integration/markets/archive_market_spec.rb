require 'spec_helper'

describe "Archive Market" do
  it "changes the market state to archived" do
    market = create(:market, :state => "published")
    domain = MarketsDomain.new DummyListener.new, Market, double("user")
    domain.archive_market market.to_param
    expect(Market.last.state).to eql("archived")
  end
end

class DummyListener
  def archive_succeeded market
  end
end
