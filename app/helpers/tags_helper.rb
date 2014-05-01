module TagsHelper
  def raw_tags(market)
    raw market.tags.split(/,/)
  end

end
