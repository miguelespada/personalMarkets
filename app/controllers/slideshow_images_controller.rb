class SlideshowImagesController < ApplicationController
  load_resource :only => [:edit, :destroy, :update]
  authorize_resource

  def index
    @slideshow_images = SlideshowImage.all
  end

  def new
    @slideshow_image= SlideshowImage.new
  end

  def edit
  end

  def create
    @slideshow_image = SlideshowImage.new(slideshow_image_params)

    respond_to do |format|
      if @slideshow_image.save
        format.html { redirect_to slideshow_images_path, notice: 'Slideshow image was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @slideshow_image.update(slideshow_image_params)
        format.html { redirect_to slideshows_path, notice: 'Slideshow image was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @slideshow_image.destroy
        format.html { redirect_to slideshow_images_path, 
                      notice: "Slideshow image successfully deleted." }
      else
        format.html { redirect_to slideshow_images_path, 
                      flash: { error: "Cannot delete slideshow image." }}
      end
    end
  end

  private
    def slideshow_image_params
      params.require(:slideshow_image).permit(photography_attributes: [:photo])
    end
end
