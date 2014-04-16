class StaticPagesController < ApplicationController
  layout "theme", only: [:home]
  
  def home
  end
  
  def search
  end
  
  def calendar
    from = beginning_of(number_of_weeks_from_now)
    to = end_of(number_of_weeks_from_now)

    tue = tuesday(number_of_weeks_from_now)
    wed = wednesday(number_of_weeks_from_now)
    thu = thursday(number_of_weeks_from_now)
    fri = friday(number_of_weeks_from_now)
    sat = saturday(number_of_weeks_from_now)

    @week = {:from => from, :to => to, :tue => tue, :wed => wed, :thu => thu, :fri => fri, :sat => sat}
    
    @markets = Market.search("", "", from, to)
    
    @monmarkets = Market.search("", "", from, from)
    @tuemarkets = Market.search("", "", tue, tue)
    @wedmarkets = Market.search("", "", wed, wed)
    @thumarkets = Market.search("", "", thu, thu)
    @frimarkets = Market.search("", "", fri, fri)
    @satmarkets = Market.search("", "", sat, sat)
    @sunmarkets = Market.search("", "", to, to)
  end

  def map
    @geojson = markers(Market.with_location) || ""
    respond_to do |format|
      format.html 
      format.json {render json: @geojson}
    end
  end

  private 
  def markers(markets)
    markets.collect{|market| market.to_marker(view_context.tooltip(market))} if markets.count > 0
  end

  def beginning_of(n)
    n.to_i.week.from_now.at_beginning_of_week.strftime("%d/%m/%Y")
  end

  def end_of(n)
    n.to_i.week.from_now.at_end_of_week.strftime("%d/%m/%Y")
  end

  def tuesday(n)
    (n.to_i.week.from_now.at_beginning_of_week+86400).strftime("%d/%m/%Y")
  end

  def wednesday(n)
    (n.to_i.week.from_now.at_beginning_of_week+86400*2).strftime("%d/%m/%Y")
  end

  def thursday(n)
    (n.to_i.week.from_now.at_beginning_of_week+86400*3).strftime("%d/%m/%Y")
  end

  def friday(n)
    (n.to_i.week.from_now.at_beginning_of_week+86400*4).strftime("%d/%m/%Y")
  end

  def saturday(n)
    (n.to_i.week.from_now.at_beginning_of_week+86400*5).strftime("%d/%m/%Y")
  end

  def number_of_weeks_from_now
    params[:week] ||= 0
  end

end
