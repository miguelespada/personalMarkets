class SpecialLocationsController < ApplicationController
  load_resource :only => [:show, :edit, :destroy, :update]
  authorize_resource :except => [:index, :show]

  def index
    @special_locations = SpecialLocation.all
  end

  def show
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
        format.html { redirect_to @special_location, notice: 'Special location was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @special_location.update(special_location_params)
        format.html { redirect_to @special_location, notice: 'Special location was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @special_location.destroy
    respond_to do |format|
      format.html { redirect_to special_locations_url }
    end
  end

  private
    def special_location_params
      params.require(:special_location).permit(:name, :latitude, :longitude, :photo)
    end
end
