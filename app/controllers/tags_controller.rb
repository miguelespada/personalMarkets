class TagsController < ApplicationController
  def index
    @tags = Market.tags
    @starred = Tag.all.map{ |tag| tag.name}
    respond_to do |format|
        format.html 
        format.json {render json: @starred}
    end
  end
end
