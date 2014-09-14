
class DateEvaluator

  def initialize market
    @market = market
  end

  def validate_dates!(dates)
    return true if @market.user.has_role? "admin"
    raise MarketDateException.new "Dates have to be within #{@market.max_duration} days." unless @market.within_duration?(dates)
    return true if !@market.has_been_published?
    raise MarketDateException.new "You cannot modify passed dates." if new_dates_modify_passed_dates?(dates)
    true
  end

  def new_dates_modify_passed_dates?(new_dates)
    new_dates = new_dates.split(';')
    old_dates = @market.date.split(',') 
    old_dates.each do |d|
      return true if !new_dates.include?(d) && passed(d)
    end
    false
  end

  def passed(d)
    (DateTime.parse(d) - Date.today).to_i < -1
  end
end