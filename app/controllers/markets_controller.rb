class MarketsController < ApplicationController
  def new
    @market = Market.new
  end

  def show
    @market = Market.find(params[:id])
  end

  def update
    @market = Market.find(params[:id])
    if params[:market] and params[:market][:featured]
      @market.featured = params[:market][:featured] 
      redirect_to market_path(@market), notice: 'Market was updated.'
    else
      redirect_to market_path(@market), notice: 'Market was not updated.'
    end

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

  private
    def market_params
      params.require(:market).permit(
        :name, 
        :description
        )
    end
end
