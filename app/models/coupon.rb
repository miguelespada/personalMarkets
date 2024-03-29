class Coupon
  include Mongoid::Document

  field :description, type: String
  field :price, type: Integer
  field :available, type: Integer

  belongs_to :market, class_name: "Market", inverse_of: :coupon
  has_many :transactions, class_name: "CouponTransaction", inverse_of: :coupon
  
  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :photography

  def check_buy number
    raise ArgumentError, "Incorrect number of coupons" unless number > 0 && number <= available
  end

  def buy! user, number, paymill_transaction_id
    check_buy number
    transaction = CouponTransaction.new
    transaction.user = user
    transaction.coupon = self
    transaction.number = number
    transaction.client_token = rand(36**8).to_s(36)
    transaction.paymill_transaction_id = paymill_transaction_id
    transaction.save
    self.available -= number
    self.update
  end

  def user
    market.user
  end

  def empty?
    description == ""
  end 

  def active?
    !empty? && market.published?
  end

  def self.icon
    "fa-ticket"
  end

  def initialized?
    description != nil && description != ""
  end

  def filled?
    description != nil && description != "" && available != nil && price != nil && !photography.empty?
  end

  def value
    total = 0
    transactions.each do |transaction|
      total += transaction.value
    end
    total
  end

  def paid
    total = 0
    transactions.each do |transaction|
      total += transaction.paid
    end
    total
  end

  def after_paymill
    total = 0
    transactions.each do |transaction|
      total += transaction.after_paymill
    end
    total
  end

  def market_income
    self.value * 0.85 - 0.25 
  end

  def to_pay
    (self.market_income + 0.35) / (1 - 0.034)
  end

  def benefit
    after_paymill - to_pay
  end

end
