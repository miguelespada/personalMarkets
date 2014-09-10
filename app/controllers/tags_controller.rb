class TagsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:suggested, :show, :gallery, :list]
  def index
    @tags = Tag.all
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
    @suggested = Tag.all.limit(7)
    render :layout => !request.xhr?
  end

  def gallery
    @suggested = Tag.all
    render :layout => !request.xhr?
  end

  def show
    redirect_to tags_path
  end

  def new
    @tag = Tag.new
    render "form"
  end

  def edit
    render "form"
  end

  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, 
                      notice: ControllerNotice.success('created', 'tag')}
      else
        format.html { redirect_to tags_path, flash: { error:  ControllerNotice.fail('created', 'tag') }}
      end 
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_path, notice: ControllerNotice.success('updated', 'tag') }
      else
        format.html {redirect_to tags_path, flash: { error:  ControllerNotice.fail('updated', 'tag')  }}
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.destroy
        format.html { redirect_to tags_path, 
                       notice: ControllerNotice.success('deleted', 'tag') }
      else  
        format.html { redirect_to tags_path, 
                      flash: { error: ControllerNotice.fail('deleted', 'tag') }}
      end
    end
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end
