class TagsController < ApplicationController
  def index
    @tags = Market.tags
    @starred = Tag.all.map{|t| t.name}
  end

  def create 
    Tag.create(name: params[:tag_name])
    redirect_to tags_path
  end

  def destroy
    tag = Tag.where(name: params[:tag_name])
    tag.destroy
    redirect_to tags_path
  end
end
