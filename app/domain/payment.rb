class Payment < Struct.new(:price, :quantity, :name, :token)

  def total_price
    total_price = (0.25 + (quantity * price * 1.1) ) * 100
  end

  def self.for payment_params
    new payment_params[:price], payment_params[:quantity], payment_params[:name], payment_params[:token]
  end

  def paymill_price
    total_price.to_i
  end

end