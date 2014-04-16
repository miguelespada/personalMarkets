require 'markets_domain_exception'

class MarketsDomain < Struct.new(:listener, :markets_repo, :users_repo)

  def create_market user_id, market_params
    user = users_repo.find user_id
    market = user.add_market market_params
    market.save!
    listener.create_market_succeeded market
  rescue MarketsDomainException
    listener.create_market_failed
  end

  def archive_market market_id
    my_market = markets_repo.find market_id
    my_market.archive
    listener.archive_succeeded my_market
  rescue MarketsDomainException
    listener.archive_failed market_id
  end

  def publish_market market_id
    my_market = markets_repo.find market_id
    my_market.publish
    listener.publish_succeeded my_market
  rescue MarketsDomainException
    listener.publish_failed market_id
  end

end

