module CouponsHelper
  def transactions(coupon)
    render "transactions", :transactions => coupon.transactions 
  end 
end
