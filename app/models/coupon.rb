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
end
