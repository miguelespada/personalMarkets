class MarketsController < ApplicationController
   def index
    @markets = Market.all
  end

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
    @market.update_attribute(:featured, params[:market][:featured])

    if market_params[:featured] != ""
      flash[:notice] = "Featured photo successfully updated!"
    else
        flash[:notice] = "Featured photo was removed!"
    end
    
  end

  private
    def market_params
      params.require(:market).permit(
        :name, 
        :description,
        :featured,
        :category_id
        )
    end
end
