class CategoriesController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:index, :show, :gallery, :explore_categories]

  def index
    @categories = Category.all
    respond_to do |format|
        format.html
        format.json {render json: @categories}
    end
  end

  def explore_categories
    @categories = Category.all
    render layout: false
  end

  def gallery
    @categories = Category.all
    render layout: false
  end

  def show
    redirect_to category_markets_path(@category.id)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, 
                      notice: 'Category was successfully created.' }
      else
        format.html { render action: 'new' }
      end 
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to categories_path, 
                      notice: "Category successfully deleted."}
      else  
        format.html { redirect_to categories_path, 
                      flash: { error: "Cannot delete category." }}
      end
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :photo)
    end
end
