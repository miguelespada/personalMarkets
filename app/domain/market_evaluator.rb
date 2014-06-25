class MarketEvaluator

  REQUIRED = ["name", "description", "featured", "location", "date", "schedule", "prices"]
  RECOMMENDED = ["tags", "photos"]
  PRO_RECOMMENDED = ["coupon", "url"]

  def initialize market
    @market = market
    @evaluation = MarketEvaluation.new market
  end

  def check_new_date
    return true if @market.user.has_role? "admin"
    within_one_week?(@market.date)
  end

  def check_update_date(new_date)
    return true if @market.user.has_role? "admin"
    within_one_week?(new_date)
    raise MarketDateException.new "You cannot modify passed dates." if @market.has_been_published? && modify_passed_dates?(@market.date, new_date)
  end

  def check_fields
    check_required
    check_recommended
    check_pro_recommended
    publish_available
    @evaluation
  end

  def publish_available
    unless !@market.has_coupon? || @market.pro? || @market.belongs_to_premium_user?
      @evaluation.warn_about_coupon
    end
  end

  def check_required
    REQUIRED.each do |field|
      unless @market.send("has_" + field + "?")
        @evaluation.add_error field
      end
    end
  end

  def check_recommended
    RECOMMENDED.each do |field|
      unless @market.send("has_" + field + "?")
        @evaluation.add_recommendation field
      end
    end
  end

  def check_pro_recommended
    PRO_RECOMMENDED.each do |field|
      unless @market.not_pro? || @market.send("has_" + field + "?")
        @evaluation.add_recommendation field
      end
    end
  end

  def evaluate_quality
    (REQUIRED + RECOMMENDED + PRO_RECOMMENDED).each do |field|
      yield field, field_quality(field) if block_given?
    end
  end

  def field_quality field
    QualityRule.for field, @market
  end
  
  def within_one_week?(date)
    dates = date.split(',')
    return true if dates.count < 2
    raise MarketDateException.new "Dates have to be within 7 days."  if (DateTime.parse(dates[-1]) - DateTime.parse(dates[0])).to_i >= 7
  end

  def modify_passed_dates?(date, new_date)
    dates = date.split(',')
    new_dates = new_date.split(',')
    dates.each do |d|
      passed = (DateTime.parse(d) - Date.today).to_i <= 0
      return true if !new_dates.include?(d) && passed
    end
    false
  end
end

class QualityRule

  RULES = {
    "description" => lambda do |field, market|
      return {"value" => "bad", "msg" => "Please write a description for your market!"} unless market.has_description?
      return {"value" => "regular", "msg" => "Add more details to your market description to make it better!"} if market.description.size < 50
      return {"value" => "good", "msg" => "The description of your market is awesome!"}
    end,
    "tags" => lambda do |field, market|
      return {"value" => "bad", "msg" => "Please add some tags to your market!"} unless market.has_tags?
      return {"value" => "regular", "msg" => "Add more tags to your market to make it better!"} if market.tags_array.size < 3
      return {"value" => "good", "msg" => "The tags of your market are awesome!"}
    end,
    "photos" => lambda do |field, market|
      return {"value" => "bad", "msg" => "Please add some photos to your market!"} unless market.has_photos?
      return {"value" => "regular", "msg" => "Add more photos to your market to make it prettier!"} if market.how_many_photos < 3
      return {"value" => "good", "msg" => "The photos of your market are awesome!"}
    end,
    "url" => lambda do |field, market|
      generic_for_recommended field, market
    end,
    "coupon" => lambda do |field, market|
      generic_for_recommended field, market
    end,
    "prices" => lambda do |field, market|
      generic_quality field, market
    end
  }

  def self.for field, market
    specific_quality = RULES[field]
    if specific_quality
      specific_quality.call field, market
    else
      generic_quality field, market
    end
  end

  def self.generic_quality field, market
    unless market.send("has_" + field + "?")
      return {"value" => "bad", "msg" => "Please fill in the " + field + " field of your market!"}
    else
      return {"value" => "good", "msg" => "The " + field + " of your market is awesome!"}
    end
  end

  def self.generic_for_recommended field, market
    if market.pro?
      unless market.send("has_" + field + "?")
        return {"value" => "regular", "msg" => "You can add " + field + " to your market to make it better!"}
      else
        return {"value" => "good", "msg" => "The " + field + " of your market is awesome!"}
      end
    else
      return {"value" => "regular", "msg" => "Update to VIM to add " + field + " to your market!"}
    end
  end

end

