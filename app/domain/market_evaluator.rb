class MarketEvaluator

  REQUIRED = ["name", "description", "featured", "location", "date", "schedule"]
  RECOMMENDED = ["tags", "url", "prices"]
  PRO_RECOMMENDED = ["coupon", "photos"]

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
      return "bad" unless market.has_description?
      return "regular" if market.description.size < 50
      return "good"
    end,
    "tags" => lambda do |field, market|
      return "bad" unless market.has_tags?
      return "regular" if market.tags_array.size < 3
      return "good"
    end,
    "photos" => lambda do |field, market|
      return "bad" unless market.has_photos?
      return "regular" if market.how_many_photos < 3
      return "good"
    end,
    "url" => lambda do |field, market|
      generic_for_recommended field, market
    end,
    "coupon" => lambda do |field, market|
      generic_for_recommended field, market
    end,
    "prices" => lambda do |field, market|
      generic_for_recommended field, market
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
      return "bad"
    else
      return "good"
    end
  end

  def self.generic_for_recommended field, market
    unless market.send("has_" + field + "?")
      return "regular"
    else
      return "good"
    end
  end

end

