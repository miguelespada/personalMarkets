class MarketsController < ApplicationController
  before_filter :load_user

  def index
    @markets ||= Market.find_all(@user)

    respond_to do |format|
        format.html 
        format.json {render json: @markets}
    end
  end

  def search
    @category_query = ""
    if params[:category] and params[:category][:category_id]
      @category_query = params[:category][:category_id]
    end
    
    @markets = Market.search(params[:query], @category_query)
    render 'index' 
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
        :category,
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
