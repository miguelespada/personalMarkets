class Wish
  include Mongoid::Document
  include Mongoid::Taggable
  field :description, type: String

  belongs_to :user, class_name: "User", inverse_of: :wishes

  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :delete
  accepts_nested_attributes_for :photography
end
