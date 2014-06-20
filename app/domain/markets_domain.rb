require 'markets_domain_exception'
require 'market_required_field_exception'

class MarketsDomain < Struct.new(:listener, :markets_repo, :users_repo)

  def initialize_market
    markets_repo.initialize_market
  end

  def create_market user_id, market_params
    user = users_repo.find user_id
    market = user.add_market market_params
    MarketEvaluator.new(market).check_new_date
    market.save!
    listener.create_market_succeeded market
  rescue MarketsDomainException
    listener.create_market_failed market, "Create market failed."
  rescue MarketDateException => e
    listener.update_failed market, e.message
  end

  def update_market market_id, market_params
    market = markets_repo.find market_id
    MarketEvaluator.new(market).check_update_date(market_params[:date])
    market.update! market_params
    ### This update should be automatic but it does not work
    market.coupon.update! market_params[:coupon_attributes] 
    ####
    listener.update_suceeded market
  rescue MarketsDomainException
    listener.update_failed market, "Market update failed."
  rescue MarketDateException => e
    listener.update_failed market, e.message
  end

  def get_market market_id
    markets_repo.find market_id
  end

  def archive_market market_id
    my_market = markets_repo.find market_id
    my_market.archive
    listener.archive_succeeded my_market
  rescue MarketsDomainException
    listener.archive_failed market_id
  end

  def unpublish_market market_id
    my_market = markets_repo.find market_id
    my_market.unpublish
    listener.unpublish_succeeded my_market
  rescue MarketsDomainException
    listener.unpublish_failed market_id
  end

  def publish_market market_id
    my_market = markets_repo.find market_id
    market_evaluation = check_fields my_market
    if !market_evaluation.warn_about_coupon?
      my_market.publish
      listener.publish_succeeded my_market
    else
      listener.publish_not_available my_market, market_evaluation
    end
  rescue MarketsDomainException
    listener.publish_failed market_id
  rescue MarketRequiredFieldException => e
    listener.publish_missing_required my_market, e.message
  end

  def publish_market! market_id
    my_market = markets_repo.find market_id
    my_market.publish
    listener.publish_succeeded my_market
  rescue MarketsDomainException
    listener.publish_failed market_id
  end

  def check_fields market
    evaluation = MarketEvaluator.new(market).check_fields
    unless evaluation.valid?
      raise MarketRequiredFieldException.new evaluation.error_message
    end
    evaluation
  end


  def make_pro market_id, pro_payment
    market = markets_repo.find market_id
    PaymillWrapper.create_transaction market.user.email, pro_payment
    market.go_pro
    market
  end
  
  def force_make_pro market_id
    market = markets_repo.find market_id
    market.go_pro
    market
  end

  def user_markets user_id
    markets = []
    if !user_id.nil?
      user = users_repo.find user_id
      markets = markets_repo.user_markets user
    end
    listener.user_markets_succeeded markets
  end

  def show_market market_id
    market = get_market market_id
    listener.show_succeeded market
  end

  def delete_market market_id
    market = get_market market_id
    market.destroy
    listener.delete_succeeded
  end

  def published_markets
    markets = markets_repo.published_markets
    listener.published_succeeded markets
  end

end

