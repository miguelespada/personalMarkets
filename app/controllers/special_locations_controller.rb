class SpecialLocationsController < ApplicationController
  before_action :set_special_location, only: [:show, :edit, :update, :destroy]

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
      format.json { head :no_content }
    end
  end

  private
    def set_special_location
      @special_location = SpecialLocation.find(params[:id])
    end

    def special_location_params
      params.require(:special_location).permit(:name, :latitude, :longitude)
    end
end
