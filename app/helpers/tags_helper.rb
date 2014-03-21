module TagsHelper
  def raw_tags(market)
    raw market.tags.split(/,/)
  end

  def tag_link(tag)
    content_tag :div, link_to(tag, markets_search_path({"query" => tag }))
  end

  def tag_list(tags, &block)
    tags.collect{|tag| concat(tag_link(tag))}
    yield if block_given?
  end
end
