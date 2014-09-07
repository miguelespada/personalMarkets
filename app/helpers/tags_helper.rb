module TagsHelper
  def raw_tags(market)
    raw market.tags.split(/,/)
  end

  def market_counter(tag)
  	Market.tagged_with(tag).count
  end
end
