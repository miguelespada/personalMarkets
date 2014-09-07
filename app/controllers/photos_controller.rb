class PhotosController < ApplicationController
  load_resource :except => [:index, :list_user_photos]
  authorize_resource :except => [:list_user_photos, :show]
  after_filter "save_my_previous_url", only: [:new, :edit]

  def index
    @photos = Photo.all.desc(:created_at).page(params[:page]).per(6)
  end

  def list_user_photos
    @photos = Photo.desc(:created_at).non_empty.collect{|photo| photo if photo.is_owner?(load_user)}.compact.uniq.reverse
    @photos = Kaminari.paginate_array(@photos).page(params[:page]).per(6)
    render "index"
  end

  def show
  end

  def crop
    @photo.crop = load_crop
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: ControllerNotice.success('updated', 'foto') }
      else
        format.html { render action: 'edit', 
              flash: { error: ControllerNotice.fail('updated', 'slideshow_image') } }
      end
    end
  end

  def edit
  end

  def destroy
    respond_to do |format|
      if @photo.destroy
        format.html { redirect_to @photo.photographic, 
                      notice: ControllerNotice.success('deleted', 'photo') }
      else
        format.html { redirect_to :back, 
                  flash: { error: ControllerNotice.fail('deleted', 'photo') } }
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

    def save_my_previous_url
      session[:my_previouse_url] = URI(request.referer).path
    end

end