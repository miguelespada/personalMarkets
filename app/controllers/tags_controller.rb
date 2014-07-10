class TagsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:suggested, :show, :gallery, :list]
  def index
    @suggested = Tag.all
    @tags = Market.tags
    respond_to do |format|
        format.html 
    end
  end

  def suggested
    @suggested = Tag.all.collect{|tag| tag.name}
    respond_to do |format|
      format.json {render json: @suggested}
    end
  end

  def list
    @suggested = Tag.all.collect{|tag| tag if tag.has_markets?}.compact.uniq.take(6)
    render :layout => !request.xhr?
  end

  def gallery
    @tags = Market.tags
    render :layout => !request.xhr?
  end

  def show
    redirect_to tags_path
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, 
                      notice: 'Tag was successfully created.' }
      else
        format.html { render action: 'new' }
      end 
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_path, notice: 'Tag was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.destroy
        format.html { redirect_to tags_path, 
                      notice: "Tag successfully deleted."}
      else  
        format.html { redirect_to tags_path, 
                      flash: { error: "Cannot delete tag." }}
      end
    end
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end
