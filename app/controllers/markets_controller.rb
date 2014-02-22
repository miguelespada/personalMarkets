class MarketsController < ApplicationController
  def index
  end
  
  def new
   	@market = Market.new
  end

  def create
  	flash[:notice] = 'Market was successfully created.'
  	redirect_to action: 'index'
  end
end
