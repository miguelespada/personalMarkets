class MarketEvaluator

  REQUIRED = ["name", "description", "featured", "location", "date", "schedule"]
  RECOMMENDED = ["tags"]
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

end

