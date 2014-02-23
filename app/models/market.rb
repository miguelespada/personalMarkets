class Market
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  has_attachment  :featured, accept: [:jpg, :png, :gif]
end