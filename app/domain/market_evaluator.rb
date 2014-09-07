class MarketEvaluator
  REQUIRED = ["name", "description", "category", "featured", "location", "schedule"]
  RECOMMENDED = ["tags", "prices", "slideshow"]
  PRO_RECOMMENDED = ["coupon", "url", "social", "extra_photos"]

  def initialize market
    @market = market
    @evaluation = MarketEvaluation.new market
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
  
end

class QualityRule

  RULES = {
    "description" => lambda do |field, market|
      return {"value" => "bad", "msg" => I18n.t(:required_field)} unless market.has_description?
      return {"value" => "regular", "msg" => I18n.t(:better_description)} if market.description.size < 50
      return {"value" => "good", "msg" => I18n.t(:awesome)}
    end,
    "tags" => lambda do |field, market|
      return {"value" => "bad", "msg" => I18n.t(:required_field)} unless market.has_tags?
      return {"value" => "regular", "msg" => I18n.t(:better_tags)} if market.tags_array.size < 3
      return {"value" => "good", "msg" => I18n.t(:awesome)}
    end,
    "slideshow" => lambda do |field, market|
      return {"value" => "regular", "msg" => I18n.t(:recommend_slideshow)} if market.how_many_photos == 0
      return {"value" => "regular", "msg" => I18n.t(:better_slideshow)} if market.how_many_photos < 3
      return {"value" => "good", "msg" => I18n.t(:awesome)}
    end,
    "url" => lambda do |field, market|
      generic_for_recommended field, market
    end,
    "social" => lambda do |field, market|
      generic_for_recommended field, market
    end,
    "coupon" => lambda do |field, market|
      coupon_quality field, market
    end,
    "extra_photos" => lambda do |field, market|
      return {"value" => "regular", "msg" => I18n.t(:better_slideshow)} if market.how_many_photos < 6
      return {"value" => "good", "msg" => I18n.t(:awesome)}
    end,
    "prices" => lambda do |field, market|
      return {"value" => "regular", "msg" => I18n.t(:recommended)} unless market.has_prices?
      return {"value" => "good", "msg" => I18n.t(:awesome)}
    end,
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
      return {"value" => "bad", "msg" => I18n.t(:required_field)}
    else
      return {"value" => "good", "msg" => I18n.t(:awesome)}
    end
  end

  def self.generic_for_recommended field, market
    if market.pro?
      unless market.send("has_" + field + "?") 
        return {"value" => "regular", "msg" => I18n.t(:recommended)}
      else
        return {"value" => "good", "msg" => I18n.t(:awesome)}
      end
    else
      return {"value" => "regular", "msg" => I18n.t(:update_vim)}
    end
  end

  def self.coupon_quality field, market
    if market.pro?
      unless market.send("has_" + field + "?")
        return {"value" => "bad", "msg" => I18n.t(:coupon_required_fields)} if market.coupon_initialized?
        return {"value" => "regular", "msg" => I18n.t(:coupon_recommended)}
      else
        return {"value" => "good", "msg" => I18n.t(:awesome)}
      end
    else
      return {"value" => "regular", "msg" => I18n.t(:update_vim)}
    end
  end

end

