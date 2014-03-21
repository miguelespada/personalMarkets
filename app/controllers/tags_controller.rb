class TagsController < ApplicationController
  def index
    @tags = Market.tags
    @starred = STARRED_TAGS["tags"]
    respond_to do |format|
        format.html 
        format.json {render json: @starred}
    end
  end
end
