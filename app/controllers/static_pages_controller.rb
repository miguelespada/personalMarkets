class StaticPagesController < ApplicationController  
  def home
  end

  def sell_coupon_terms
  end

  def buy_coupon_terms
  end

  def map
    if params[:location].present?
      session[:location] = params[:location]
    end
  end

  def settings
    authorize! :admin, Market
  end

end

