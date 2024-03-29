class CategoriesController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:show, :gallery, :list]

  def index
    @categories = Category.all
    respond_to do |format|
        format.html
        format.json {render json: @categories}
    end
  end

  def list
    @categories = Category.all
    render :layout => !request.xhr?
  end

  def gallery
    @categories = Category.all.limit(params['limit'] || 20 ) 
    render :layout => !request.xhr?
  end

  def show
    redirect_to categories_path
  end

  def new
    @category = Category.new
    render 'form'
  end

  def edit
    @category.glyph_img ||= Photo.new
    render 'form'
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, 
                      notice: ControllerNotice.success('created', 'category') }
      else
        format.html { redirect_to categories_path, 
                    flash: { error: ControllerNotice.fail('created', 'category') } }
      end 
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: ControllerNotice.success('updated', 'category') }
      else
        format.html { redirect_to categories_path, 
                    flash: { error: ControllerNotice.fail('updated', 'category') } }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to categories_path, 
                      notice: ControllerNotice.success('deleted', 'category')}
      else  
        format.html { redirect_to categories_path, 
                    flash: { error: ControllerNotice.fail('deleted', 'category') } }
      end
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :english, :style, :order, :glyph, :color, :glyph_img,
                    photography_attributes: [:photo])
    end
end
