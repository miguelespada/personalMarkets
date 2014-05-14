class PhotosController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :list_user_photos, :show]
  
  def index
    @photos = Photo.all.page(params[:page]).per(2)
  end

  def list_user_photos
    @photos = Photo.all.collect{|photo| photo if photo.is_owner?(load_user)}
    @photos = Kaminari.paginate_array(@photos).page(params[:page]).per(2)
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

  def destroy
    respond_to do |format|
      if @photo.destroy
        format.html { redirect_to :back, 
                      notice: "Photo successfully deleted." }
      else
        format.html { redirect_to :back, 
                      flash: { error: "Cannot delete special photo." }}
      end
    end
  end

  private 
    def load_crop
      {"x" => params[:x], "y" => params[:y], "w" => params[:w], "h" => params[:h]}
    end

    def load_user
      User.find(params[:user_id])
    end
end