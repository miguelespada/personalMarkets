class Wish
  include Mongoid::Document
  include Mongoid::Taggable
  field :description, type: String

  belongs_to :user, class_name: "User", inverse_of: :wishes

  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy

  has_and_belongs_to_many :recommended, class_name: "Market", inverse_of: :recommended

  accepts_nested_attributes_for :photography

  def recommend(market)
    recommended << market
  end

  def self.icon
    "fa-magic"
  end
end
