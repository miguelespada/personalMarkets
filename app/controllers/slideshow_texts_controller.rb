class SlideshowTextsController < ApplicationController
  load_resource :only => [:edit, :destroy, :update]
  authorize_resource

  def index
    @slideshow = SlideshowText.all
  end

  def new
    @slideshow_text= SlideshowText.new
  end

  def edit
  end

  def create
    @slideshow_text = SlideshowText.new(slideshow_text_params)

    respond_to do |format|
      if @slideshow_text.save
        format.html { redirect_to slideshow_texts_path, notice: 'Slideshow text was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @slideshow_text.update(slideshow_text_params)
        format.html { redirect_to slideshow_texts_path, notice: 'Slideshow text was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @slideshow_text.destroy
        format.html { redirect_to slideshow_texts_path, 
                      notice: "Slideshow text successfully deleted." }
      else
        format.html { redirect_to slideshow_texts_path, 
                      flash: { error: "Cannot delete slideshow text." }}
      end
    end
  end

  private
    def slideshow_text_params
      params.require(:slideshow_text).permit(:title, :subtitle, :title_en, :subtitle_en)
    end
end
