class Bargain
  include Mongoid::Document
  field :description, type: String

  belongs_to :user, class_name: "User", inverse_of: :bargains

  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :delete
  accepts_nested_attributes_for :photography
end
