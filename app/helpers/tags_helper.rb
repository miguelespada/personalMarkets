module TagsHelper
  def raw_tags(market)
    raw market.tags.split(/,/)
  end
  def raw_suggested_tags(tags)
    raw tags.map{ |tag| tag.name }
  end
end
