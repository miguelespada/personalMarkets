class SpecialLocationsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:index, :show, :gallery, :explore_hotspots]

  def index
    @special_locations = SpecialLocation.all
    respond_to do |format|
        format.html
        format.json {render json: @special_locations}
    end
  end

  def explore_hotspots
    @special_locations = SpecialLocation.all
    render layout: false
  end

  def gallery
    @special_locations = SpecialLocation.all
    render layout: false
  end

  def new
    @special_location = SpecialLocation.new
  end

  def edit
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
      params.require(:special_location).permit(:name, :address, :city, :latitude, :longitude, :photo)
    end
end
