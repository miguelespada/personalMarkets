class SpecialLocationsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:show, :gallery, :list, :get_location]

  def index
    @special_locations = SpecialLocation.all
    respond_to do |format|
        format.html
        format.json {render json: @special_locations}
    end
  end

  def get_location
    location = SpecialLocation.find_by(name: params['name'])

    respond_to do |format|
        format.json {render json: location}
    end
  end

  def list
    @special_locations = SpecialLocation.where(important: true)
    render :layout => !request.xhr?
  end

  def gallery
    @special_locations = SpecialLocation.all.limit(params['limit'] || 20)
    render :layout => !request.xhr?
  end
  
  def show
    redirect_to special_locations_path
  end 

  def new
    @special_location = SpecialLocation.new
    render 'form'
  end

  def edit
    render 'form'
  end

  def create
    @special_location = SpecialLocation.new(special_location_params)

    respond_to do |format|
      if @special_location.save
        format.html { redirect_to special_locations_path, notice: 'Special location was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @special_location.update(special_location_params)
        format.html { redirect_to special_locations_path, notice: 'Special location was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @special_location.destroy
        format.html { redirect_to special_locations_path, 
                      notice: "Special location successfully deleted." }
      else
        format.html { redirect_to special_locations_path, 
                      flash: { error: "Cannot delete special location." }}
      end
    end
  end

  private
    def special_location_params
      params.require(:special_location).permit(:name, :address, :city, :latitude, :longitude, :important, photography_attributes: [:photo])
    end
end
