class MarketsController < ApplicationController
  before_filter :load_user

   def index
    @markets = @user.markets.all
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
        :_id, 
        :user_id,
        [:signature, :created_at, :tags, :bytes, :type, :etag, :url, :secure_url],
        :category_id
        )
    end
    def load_user
     @user = User.find(params[:user_id])
   end
end
