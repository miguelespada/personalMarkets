class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    respond_to do |format|
        format.html
        format.json {render json: @categories}
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
      else
        format.html { render action: 'new' }
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
                      :flash => { :error => "Cannot delete category." }}
      end
    end

  end
  
  private
    def category_params
      params.require(:category).permit(:name)
    end
end
