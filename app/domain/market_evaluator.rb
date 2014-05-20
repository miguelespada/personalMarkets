class MarketEvaluator

  def initialize market
    @market = market
    @evaluation = MarketEvaluation.new market
  end

  def check_fields
    check_name
    check_description
    check_featured
    check_location
    check_date
    check_tags
    @evaluation
  end

  def check_tags
    unless @market.has_tags?
      @evaluation.add_recomendation "tags"
    end
  end

  def check_name
    unless @market.name?
      @evaluation.add_error "name"
    end
  end

  def check_description
    unless @market.description?
      @evaluation.add_error "description"
    end
  end

  def check_featured
    unless @market.has_featured?
      @evaluation.add_error "featured"
    end
  end

  def check_location
    unless @market.has_location?
      @evaluation.add_error "location"
    end
  end

  def check_date
    unless @market.date?
      @evaluation.add_error "date"
    end
  end

end

class MarketEvaluation

  def initialize market
    @market = market
    @valid = true
  end

  def valid?
    @valid
  end

  def could_be_better?
    !@recomendations.nil? && !@recomendations.empty?
  end

  def add_error field
    @valid = false
    @fields ||= []
    @fields << field
  end

  def add_recomendation field
    @recomendations ||= []
    @recomendations << field
  end

  def error_message
    @fields.join(", ")
  end

  def recomendation_message
    @recomendations.join(", ")
  end

end