class MarketsController < ApplicationController
  before_filter :load_user

  def index
    @markets = []
    if !Market.es.index.exists? 
      Market.es.index_all
    end

    if @user
      if params[:query].present?
        @markets = Market.es.search (params[:query] + " AND " + @user.to_param)
      else
        @markets = @user.markets.all
      end
    else
      if params[:query].present?
        @markets = Market.es.search params[:query]
      else
        @markets = Market.all
      end
    end
  end

  def new
    @market = @user.markets.new
  end

  def show
    @market = @user.markets.find(params[:id])
  end
  
  def edit
    @market = @user.markets.find(params[:id])
  end

  def create
    @market = @user.markets.new(market_params)
    @market.save
    respond_to do |format|
      if @market.save
        format.html {redirect_to [@user, @market], notice: 'Market was successfully created.' }
      else
        format.html { render action: 'new' }
      end 
    end
  end


  def update
    @market = @user.markets.find(params[:id])
    respond_to do |format|
      if @market.update(market_params)
        format.html { redirect_to [@user, @market], 
                      notice: "Market successfully updated."}
      end
    end
  end

  def destroy
    @market = @user.markets.find(params[:id])
    @market.destroy
    respond_to do |format|
      format.html { redirect_to  user_markets_path(@user) }
    end
  end

  private
    def market_params
      params.require(:market).permit(
        :name, 
        :description,
        :featured, 
        [:signature, :created_at, :tags, :bytes, :type, :etag, :url, :secure_url],
        :_id,
        :query, 
        :user_id,
        :category_id
        )
    end
    def load_user
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      end 
   end
end
