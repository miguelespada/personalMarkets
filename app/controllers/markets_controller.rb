class MarketsController < ApplicationController
  def new
    @market = Market.new
  end

  def show
    @market = Market.find(params[:id])
  end

  def create
    @market = Market.new(market_params)
    respond_to do |format|
      if @market.save
        format.html { redirect_to market_path(@market), notice: 'Market was successfully created.' }

      else
        format.html { render action: 'new' }
      end
    end
  end


  def update
    @market = Market.find(params[:id])
    if market_params[:featured]
      @market.update_attribute(:featured, market_params[:featured])
    end
  end

  private
    def market_params
      params.require(:market).permit(
        :name, 
        :description,
        :featured
        )
    end
end
