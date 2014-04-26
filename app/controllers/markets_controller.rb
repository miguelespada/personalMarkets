class MarketsController < ApplicationController
  before_filter :load_user
  before_filter :load_hidden_tags, only: [:create, :edit, :update]

  # def destroy
  #   @market.destroy
  #   respond_to do |format|
  #     format.html { redirect_to  user_markets_path(@user), 
  #                     notice: "Market successfully deleted."}
  #   end
  # end

  def index
    @markets = Market.all
    render 'index', :locals =>  {:layout => "slugs"}
  end

  def list_user_markets
    @markets = Market.find_all(@user)
    render 'index', :locals =>  {:layout => "slugs"}
  end

  def search
    @markets = Market.search(search_params)
    render 'index', :layout => false
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
    @market.coupon = Coupon.new
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

  # def index
  #   domain.user_markets params[:user_id]
  # end

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
  rescue CanCan::AccessDenied
    render status: 401, text: "Unauthorized action"
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
    domain.published_markets
  end

  def published_succeeded markets
    @markets = markets
    render 'index', :locals =>  {:layout => false}
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
        :date,
        :from,
        :to,
        "hidden-market",
        [:signature, :created_at, :tags, :bytes, :type, :etag, :url, :secure_url],
        :_id,
        :query, 
        :category,
        :city_name,
        :user_id,
        :category_id,
        :location_id,
        :coupon_attributes => [:id, :description, :price, :available]
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

    def load_category
        params[:category][:category_id]
    rescue => e
        ""
    end

    def load_latitude
      SpecialLocation.find_by(name: params[:location][:location_id]).latitude
    rescue => e
        ""
    end 

    def load_longitude
      SpecialLocation.find_by(name: params[:location][:location_id]).longitude
    rescue => e
        ""
    end

    def load_city
        params[:city][:city_name]
    rescue => e
        ""
    end

    def load_from
        params[:from]
    rescue => e
        ""
    end

    def load_to
        params[:to]
    rescue => e
        ""
    end

    def load_query
        params[:query]
    rescue => e
        ""
    end

    def search_params
      {
        :query => load_query,
        :form => load_to,
        :to => load_from,
        :latitude => load_latitude,
        :longitude => load_longitude,
        :category => load_category,
        :city => load_city
      }
    end 
end
