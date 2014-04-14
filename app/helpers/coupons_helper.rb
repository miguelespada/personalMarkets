module CouponsHelper
  def transactions(coupon)
    if coupon.market.user == current_user
      render "transactions", :transactions => coupon.transactions 
    end
  end 
end
