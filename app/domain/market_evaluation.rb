class MarketEvaluation

  def initialize market
    @market = market
    @valid = true
    @coupon_warning = false
  end

  def valid?
    @valid
  end

  def could_be_better?
    !@recommendations.nil? && !@recommendations.empty?
  end

  def warn_about_coupon
    @coupon_warning = true
  end

  def warn_about_coupon?
    @coupon_warning
  end

  def add_error field
    @valid = false
    @fields ||= []
    @fields << field
  end

  def add_recommendation field
    @recommendations ||= []
    @recommendations << field
  end

  def error_message
    @fields.join(", ")
  end

  def recommendation_message
    @recommendations.join(", ")
  end

end