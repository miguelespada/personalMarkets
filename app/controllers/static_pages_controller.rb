class StaticPagesController < ApplicationController
  def home
  end
  
  def search
  end
  
  def calendar
    from = beginning_of(number_of_weeks_from_now)
    to = end_of(number_of_weeks_from_now)
    @week = {:from => from, :to => to}
    @markets = Market.search("", "", from, to)
  end

  def map
    @geojson = generate_geojson(Market.with_location) || ""
    respond_to do |format|
      format.html 
      format.json {render json: @geojson}
    end
  end

  private 
  
  def generate_geojson(markets)
    markets.collect{|market| market.to_marker(view_context.tooltip(market))} if markets.count > 0
  end

  def beginning_of(n)
    n.to_i.week.from_now.at_beginning_of_week.strftime("%d/%m/%Y")
  end

  def end_of(n)
    n.to_i.week.from_now.at_end_of_week.strftime("%d/%m/%Y")
  end

  def number_of_weeks_from_now
    params[:week] ||= 0
  end

end
