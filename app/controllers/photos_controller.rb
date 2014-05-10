class PhotosController < ApplicationController
  load_resource
  
  def index
    @photos = Photo.all
  end

  def show
  end

  def crop
    @photo.crop = load_crop
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo sucessfully updated.' }
      else
        format.html { render action: 'edit', notice: 'Error updating the photo' }
      end
    end
  end

  def edit
  end

  private 
    def load_crop
      {"x" => params[:x], "y" => params[:y], "w" => params[:w], "h" => params[:h]}
    end
end