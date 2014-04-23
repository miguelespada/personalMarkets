class Wish
  include Mongoid::Document
  field :description, type: String
  has_attachment :wish_photo, accept: [:jpg, :png, :gif]

  belongs_to :user, class_name: "User", inverse_of: :wishes
end
