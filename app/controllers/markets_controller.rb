class MarketsController < ApplicationController
  before_filter :load_user
  before_filter :load_hidden_tags, only: [:create, :edit, :update]
  authorize_resource :only => [:index, :edit, :create, :new, :destroy, :update, :archive, 
                              :publish, :unpublish, :make_pro, :publish_anyway]

  def index
    @markets = Market.all
  end

  def slideshow
    @markets = Market.last_published
    render :layout => !request.xhr?
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
    query = Query.new(params, session)
    result = Market.search(query.search_params, params[:page].to_i, 6)
    @markets = result[:market]
    @total = result[:total]
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
    3.times {@market.gallery.photographies << Photo.new}
  end

  def show
    market = Market.find params[:id]
    Tracker.market_visit params[:id], visitor unless visitor.owns(market)
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
  end

  def user_markets_succeeded markets
    @markets = markets
    respond_to do |format|
        format.json {render json: markets}
        format.html
    end
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
    domain.archive_market params[:market_id]
  end

  def archive_succeeded market
    redirect_to market, notice: "Market successfully archived."
  end

  def unpublish
    domain.unpublish_market params[:market_id]
  end

  def unpublish_succeeded market
    redirect_to market, notice: "Market successfully unpublished."
  end

  def publish
    domain.publish_market params[:market_id]
  end

  def publish_anyway
    domain.publish_market! params[:market_id]
  end

  def publish_not_available market
    flash[:error] = "In order to publish a market with a coupon you should make it PRO or become PREMIUM. Otherwise the coupon won't be available. #{view_context.link_to "Publish anyway", market_publish_anyway_path(market), { method: :post }}".html_safe
    redirect_to market
  end

  def publish_succeeded market
    redirect_to market, notice: "Market successfully published."
  end

  def published_succeeded markets
    @markets = markets
    render 'index', :locals =>  {:layout => false}
  end

  def update
    domain.update_market params[:id], market_params
  end

  def update_suceeded market
    redirect_to market, notice: "Market successfully updated."
  end

  def update_failed market
    redirect_to market, notice: "Market update failed."
  end

  def make_pro_payment
    payment = Payment.new ENV['PRO_PRICE'].to_f, 1
    @pro_payment = MarketProPayment.new Market.find(params[:market_id]), payment
  end

  def make_pro
    payment = Payment.for payment_params
    pro_payment = MarketProPayment.new Market.find(params[:id]), payment

    market = domain.make_pro params[:id], pro_payment
    redirect_to market, notice: "Your market is now PRO."
  end

  private

  def payment_params
    {
      name: params['name'],
      price: params['price'].to_f,
      quantity: params[:quantity].to_i,
      token: params['paymill_card_token']
    }
  end

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
        :user_lat,
        :user_lon,
        :coupon_attributes => [:id, :description, :price, :available, :photography_attributes => [:id, :photo]],
        :featured_attributes => [:id, :photo],
        :gallery_attributes => [:id, :photographies_attributes => [:id, :photo]]
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

    def buy_params
      buy_params = {
        :name => params[:name],
        :token => params[:paymill_card_token],
        :price => params[:total_price]
      }
    end

    def visitor
      MarketVisitor.new current_user
    end

end
