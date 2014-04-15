class MarketsController < ApplicationController
  before_filter :load_user
  before_filter :load_market, only: [:show ,:edit, :update, :destroy]

  def publish
    @market = Market.find(params[:market_id])
    @market.publish
    redirect_to @market, notice: "Market successfully published."
  end

  def published
    @markets = Market.where(state: :published)
  end

  def index
    @markets ||= Market.find_all(@user)
    respond_to do |format|
        format.html 
        format.json {render json: @markets}
        format.xml {render xml: @markets}
    end
  end

  def search
    @category_query = load_category
    @markets = Market.search(params[:query], @category_query, 
                            params[:from], params[:to])
    render 'index' 
  end

  def new
    @market = Market.new
  end

  def show
    respond_to do |format|
        format.html   
        format.svg  { render :qrcode => request.url, :level => :l, :unit => 10 }
    end
  end
  
  def edit
  end

  def create
    @market = @user.markets.new(market_params)
    @market.save!
    redirect_to @market, notice: 'Market was successfully created.'
  rescue Exception
    flash[:notice] = "Something went wrong."
    render action: 'new'
  end

  def update
    authorize! :update, @market
    load_hidden_tags
    @market.update!(market_params)
    redirect_to @market, notice: "Market successfully updated."
  rescue CanCan::AccessDenied
    render :status => 401, :text => "Unauthorized action"
  end

  def destroy
    @market.destroy
    respond_to do |format|
      format.html { redirect_to  user_markets_path(@user), 
                      notice: "Market successfully deleted."}
    end
  end

  def delete_image
    @market = Market.find(params[:market_id])
    authorize! :delete_image, @market
    @market.featured = nil
    @market.save!
    respond_to do |format|
      format.html { redirect_to @market, notice: "Market picture deleted."}
    end
  rescue CanCan::AccessDenied
    render status: 401, text: "Unauthorized action"
  end

  private
    def market_params
      params.require(:market).permit(
        :name, 
        :description,
        :featured,
        :address,
        :latitude,
        :longitude,
        :tags,
        :date,
        :from,
        :to,
        "hidden-market",
        [:signature, :created_at, :tags, :bytes, :type, :etag, :url, :secure_url],
        :_id,
        :query, 
        :category,
        :user_id,
        :category_id,
        )
    end
    def load_hidden_tags
      if params["hidden-market"].present?
        params[:market][:tags] += "," + params["hidden-market"][:tags]
      end
    end 
    
    def load_user
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      end 
    end

    def load_market
      @market = Market.find(params[:id])
    end
    
    def load_category
        params[:category][:category_id]
    rescue => e
        ""
    end 
end
