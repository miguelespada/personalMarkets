class StaticPagesController < ApplicationController  
  def home
  end

  def coupon_terms
  end

  def map
    if params[:location].present?
      session[:location] = params[:location]
    end
  end

end

