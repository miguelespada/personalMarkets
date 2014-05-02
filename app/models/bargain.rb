class Bargain
  include Mongoid::Document
  field :description, type: String
  has_attachment :photo, accept: [:jpg, :png, :gif]

  belongs_to :user, class_name: "User", inverse_of: :wishes
end
