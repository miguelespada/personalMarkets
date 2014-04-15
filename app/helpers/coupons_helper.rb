module CouponsHelper
  def transactions(coupon)
    render "transactions", :transactions => coupon.transactions if can? :edit, coupon.market
  end 
end
