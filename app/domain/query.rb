class Query
  def initialize(params, session)
    @params = params
    @session = session 
    search_params
  end

  def search_params

        puts "*-*" * 20
        puts @session.to_json
        puts "*-*" * 20

    {
      :query => load_query,
      :from => load_from,
      :to => load_to,
      :range => load_range,
      :latitude => load_latitude,
      :longitude => load_longitude,
      :category => load_category,
      :city => load_city
    }
  end 

  private

    def load_category
        @session[:category_id] = @params[:category][:category_id]
        @params[:category][:category_id]
    rescue 
        ""
    end

    def load_latitude
      @session[:location] = @params[:location][:location_id]
      SpecialLocation.find_by(name: @params[:location][:location_id]).latitude
    rescue 
        ""
    end 

    def load_longitude
      @session[:location_id] = @params[:location][:location_id]
      SpecialLocation.find_by(name: @params[:location][:location_id]).longitude
    rescue 
        ""
    end

    def load_city
        @session[:city] = @params[:city][:city_name]
        @params[:city][:city_name]
    rescue 
        ""
    end

    def load_from
        @session[:from] = @params[:from]
        @params[:from]
    rescue 
        ""
    end

    def load_to
        @session[:to] = @params[:to]
        @params[:to]
    rescue 
        ""
    end
    
    def load_range
        @session[:range] = @params[:range]
        @params[:range]
    rescue 
        ""
    end

    def load_query
        @session[:query] = @params[:query]
        @params[:query]
    rescue 
        ""
    end

   
end