class Bargain
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :description, type: String
  field :price, type: String

  belongs_to :user, class_name: "User", inverse_of: :bargains

  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :photography

  def self.icon
    "fa-bullhorn"
  end

  def aspect_ratio
    1
  end
end
