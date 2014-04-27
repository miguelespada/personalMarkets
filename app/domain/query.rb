class Query
  def initialize(params)
    @params = params
    search_params
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

  private

    def load_category
        @params[:category][:category_id]
    rescue => e
        ""
    end

    def load_latitude
      SpecialLocation.find_by(name: @params[:location][:location_id]).latitude
    rescue => e
        ""
    end 

    def load_longitude
      SpecialLocation.find_by(name: @params[:location][:location_id]).longitude
    rescue => e
        ""
    end

    def load_city
        @params[:city][:city_name]
    rescue => e
        ""
    end

    def load_from
        @params[:from]
    rescue => e
        ""
    end

    def load_to
        @params[:to]
    rescue => e
        ""
    end

    def load_query
        @params[:query]
    rescue => e
        ""
    end

   
end