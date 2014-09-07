class GalleryController < ApplicationController
  load_resource
  def show
    redirect_to @gallery.market
  end
end