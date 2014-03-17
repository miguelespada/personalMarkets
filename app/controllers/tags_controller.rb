class TagsController < ApplicationController
  def index
    @tags = Market.tags
    @starred = Tag.all.map{ |tag| tag.name}
  end
end
