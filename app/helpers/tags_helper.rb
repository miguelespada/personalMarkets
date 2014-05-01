module TagsHelper
  def raw_tags(market)
    raw market.tags.split(/,/)
  end

  def tag_link(tag)
    content_tag :div, link_to(tag.name, tag_markets_path(tag))
  end

end
