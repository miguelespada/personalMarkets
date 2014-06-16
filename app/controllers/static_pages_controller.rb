class StaticPagesController < ApplicationController  
  def home
  end
  
  def calendar
    from = beginning_of(number_of_weeks_from_now)
    to = end_of(number_of_weeks_from_now)
    @week = {:from => from, :to => to}
    @markets = Market.search(@week)[:markets]
  end

  def map
    if params[:location].present?
      session[:location] = params[:location]
    end
  end
  
  private 

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

