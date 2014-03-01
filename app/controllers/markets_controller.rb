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
    @market.update!(market_params)


    respond_to do |format|
      if @market.previous_changes.count > 0
        format.html { redirect_to market_path(@market), 
                      notice: "Market successfully updated."}
      else
        format.html { redirect_to market_path(@market), 
                      notice: "Nothing changes." }
      end
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
