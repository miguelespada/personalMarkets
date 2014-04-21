class MarketsController < ApplicationController
  before_filter :load_user
  before_filter :load_market, only: [:show ,:edit, :destroy]
  before_filter :load_hidden_tags, only: [:create, :edit, :update]

  def destroy
    @market.destroy
    respond_to do |format|
      format.html { redirect_to  user_markets_path(@user), 
                      notice: "Market successfully deleted."}
    end
  end

  def delete_image
    authorize! :delete_image, domain.get_market(params[:market_id])
    domain.delete_image params[:market_id]
  rescue CanCan::AccessDenied
    render status: 401, text: "Unauthorized action"
  end

  def delete_image_succeeded market
    redirect_to market, notice: "Image deleted successfully"
  end

  def index
    @markets ||= Market.find_all(@user)
    respond_to do |format|
        format.json {render json: @markets}
        format.html
    end
  end

  def search
    @category_query = load_category
    @markets = Market.search(params[:query], @category_query, 
                            params[:from], params[:to])
    render 'index', :layout => false
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
    domain.create_market params[:user_id], market_params
  end

  def create_market_succeeded market
    redirect_to market, notice: 'Market was successfully created.'
  end

  def create_market_failed
    flash[:notice] = "Something went wrong."
    render action: 'new'
  end

  def archive
    authorize! :archive, domain.get_market(params[:market_id])
    domain.archive_market params[:market_id]
  rescue CanCan::AccessDenied => e
    render status: 401, text: "Unauthorized action"
  end

  def archive_succeeded market
    redirect_to market, notice: "Market successfully archived."
  end

  def publish
    domain.publish_market params[:market_id]
  end

  def publish_succeeded market
    redirect_to market, notice: "Market successfully published."
  end

  def published
    @markets = Market.where(state: :published)
    render 'index' 
  end

  def update
    authorize! :update, domain.get_market(params[:id])
    domain.update_market params[:id], market_params
  rescue CanCan::AccessDenied
    render :status => 401, :text => "Unauthorized action"
  end

  def update_suceeded market
    redirect_to market, notice: "Market successfully updated."
  end

  def update_failed market
    redirect_to market, notice: "Market update failed."
  end

  private

    def domain
      @domain ||= MarketsDomain.new self, Market, User
    end

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
        :city,
        :user_id,
        :category_id,
        )
    end
    
    def load_hidden_tags
      if params["hidden-market"].present?
        params[:market][:tags] = params["hidden-market"][:tags]
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
