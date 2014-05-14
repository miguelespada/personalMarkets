class Payment < Struct.new(:price, :quantity, :name, :token)

  def total_price
    total_price = quantity * price * 100
  end

  def self.for payment_params
    new payment_params[:price], payment_params[:quantity], payment_params[:name], payment_params[:token]
  end

end