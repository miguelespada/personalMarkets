class TagsController < ApplicationController
  def index
    @tags = Market.tags
  end
end
