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
  
  def edit
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
    respond_to do |format|
      if @market.update(market_params)
        format.html { redirect_to market_path(@market), 
                      notice: "Market successfully updated."}
      end
    end
  end

  def destroy
    @market = Market.find(params[:id])
    @market.destroy
    respond_to do |format|
      format.html { redirect_to markets_path }
    end
  end

  private
    def market_params
      params.require(:market).permit(
        :name, 
        :description,
        :featured,
        [:signature, :created_at, :tags, :bytes, :type, :etag, :url, :secure_url],
        :category_id
        )
    end
end
