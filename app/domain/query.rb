class Query
  def initialize(params)
    @params = params
  end

  def search_params
    {
      :query => load_query,
      :from => load_from,
      :to => load_to,
      :range => load_range,
      :latitude => load_latitude,
      :longitude => load_longitude,
      :category => load_category,
      :distance => load_distance
    }
  end 

  def is_last_page?
    @result[:total]/@per_page.to_f <= @page 
  end
  def is_first_page?
    @page == 1
  end

  def set_session(session)
    if @params[:category].present? && @params[:category][:category_id].present?
      session[:category] = @params[:category][:category_id] 
      session[:style] = Category.find_by(name: session[:category]).style
    else
      session[:category] = ""
      session[:style] = nil
    end

    session[:location] = @params[:location][:location_id] if @params[:location].present?
    session[:range] = @params[:range]
    session[:query] = @params[:query]
    session[:address] = @params[:address]
  end

  def search_markets
    @per_page = @params[:per_age].present? ? @params[:per_page].to_i : 9
    @page = @params[:page].present? ? @params[:page].to_i : 1
    @result = Market.search(search_params, @page, @per_page)
    @result[:markets]
  end

  private

    def load_category
        @params[:category][:category_id]
    rescue 
        ""
    end
    
    def load_distance
      if @params[:address].present?
        "3km"
      elsif @params[:location][:location_id] == ""
        "1km"
      else
        "3km" 
      end
    rescue 
       "10km"
    end 

    def load_latitude
      if @params[:address].present?
        @params[:lat]
      elsif @params[:location][:location_id] == ""
        @params[:user_lat]
      else
        SpecialLocation.find_by(name: @params[:location][:location_id]).latitude
      end
    rescue 
        ""
    end 

    def load_longitude
      if @params[:address].present?
        @params[:lon]
      elsif @params[:location][:location_id] == ""
        @params[:user_lon]
      else
        SpecialLocation.find_by(name: @params[:location][:location_id]).longitude
      end
    rescue 
        ""
    end

    def load_from
        @params[:from]
    rescue 
        DateTime.now.strftime("%d/%m/%Y")
    end

    def load_to
        @params[:to]
    rescue 
        ""
    end
    
    def load_range
        @params[:range]
    rescue 
        ""
    end

    def load_query
        @params[:query]
    rescue 
        ""
    end

end