class Wish
  include Mongoid::Document
  field :description, type: String
  belongs_to :user, class_name: "User", inverse_of: :wishes
end
