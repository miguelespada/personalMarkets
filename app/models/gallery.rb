class Gallery
  include Mongoid::Document

  belongs_to :market, class_name: "Market", inverse_of: :gallery
  has_many :photographies, class_name: "Photo", as: :photographic, dependent: :destroy
  accepts_nested_attributes_for :photographies

  def user
    market.user
  end
  
end