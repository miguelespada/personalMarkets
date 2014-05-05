class MarketsController < ApplicationController
  before_filter :load_user
  before_filter :load_hidden_tags, only: [:create, :edit, :update]

  def index
    @markets = Market.all
  end

  def list_category_markets
    @markets = Market.with_category(load_category)
    render 'index'
  end

  def list_published_markets
    @markets = Market.published
    render 'index'
  end
  
  def list_tag_markets
    @markets = Market.tagged_with(params[:tag])
    render 'index'
  end

  def list_last_markets
    @markets = Market.last_published
    render 'search', :layout => !request.xhr?
  end

  def list_user_markets
    @markets = Market.find_all(@user)
    render 'index'
  end

  def list_liked_markets
    @markets = @user.favorites
    render 'search', :layout => !request.xhr?
  end

  def search
    query = Query.new(params)
    @markets = Market.search(query.search_params)
    render :layout => !request.xhr?
  end

  def destroy
    domain.delete_market params[:id]
  end

  def delete_succeeded
    respond_to do |format|
      format.html { redirect_to  user_markets_path(@user), 
                      notice: "Market successfully deleted."}
    end
  end

  def new
    @market = domain.initialize_market
  end

  def show
    domain.show_market params[:id]
  end

  def show_succeeded market
    @market = market
    respond_to do |format|
        format.html   
        format.svg  { render :qrcode => request.url, :level => :l, :unit => 10 }
    end
  end
  
  def edit
    @market = domain.get_market params[:id]
    @market.coupon ||= Coupon.new
  end

  def user_markets_succeeded markets
    @markets = markets
    respond_to do |format|
        format.json {render json: markets}
        format.html
    end
  end

  def delete_image
    authorize! :delete_image, domain.get_market(params[:market_id])
    domain.delete_image params[:market_id]
  end

  def delete_image_succeeded market
    redirect_to market, notice: "Image deleted successfully"
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

  def published_succeeded markets
    @markets = markets
    render 'index', :locals =>  {:layout => false}
  end

  def update
    authorize! :update, Market.find(params[:id])
    domain.update_market params[:id], market_params
  end

  def update_suceeded market
    redirect_to market, notice: "Market successfully updated."
  end

  def update_failed market
    redirect_to market, notice: "Market update failed."
  end

  private

    def domain
      @domain ||= MarketsDomain.new self, MarketsRepo, User
    end

    def market_params
      params.require(:market).permit(
        :name, 
        :description,
        :featured,
        :address,
        :latitude,
        :longitude,
        :city,
        :tags,
        :tag,
        :date,
        :from,
        :to,
        "hidden-market",
        :_id,
        :query, 
        :category,
        :city_name,
        :user_id,
        :category_id,
        :location_id,
        :coupon_attributes => [:id, :description, :price, :available, :photo],
        :featured => [],
        :photos => []
        )
    end

    
    def load_user
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      end 
    end

    def load_hidden_tags
      if params["hidden-market"].present?
        params[:market][:tags] = params["hidden-market"][:tags]
      end
    end

    def load_category
      Category.find(params[:category_id])
    end

end
