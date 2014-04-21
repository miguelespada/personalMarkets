class SpecialLocation
  include Mongoid::Document
  field :name
  field :latitude, type: Float
  field :longitude, type: Float
  validates_presence_of :name, :latitude, :longitude
  validates :name, uniqueness: { message: "Location name must be unique" }
end
