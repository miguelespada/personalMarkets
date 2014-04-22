class MarketsController < ApplicationController
  before_filter :load_user
  before_filter :load_market, only: [:destroy]
  before_filter :load_hidden_tags, only: [:create, :edit, :update]

  def search
    @category_query = load_category
    
    @location_query = SpecialLocation.find_by(name: load_location) if !load_location.blank?
    latitude = @location_query.latitude if !@location_query.nil?
    latitude ||= ""
    longitude = @location_query.longitude if !@location_query.nil?
    longitude ||= ""
    @markets = Market.search(params[:query], @category_query, 
                             params[:from], params[:to], latitude, longitude)
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
    @market = Market.new
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
  end

  def index
    domain.user_markets params[:user_id]
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
        :location_id
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

    def load_location
        params[:location][:location_id]
    rescue => e
        ""
    end 
end
