class SpecialLocation
  include Mongoid::Document
  field :name
  field :city, type: String
  field :address, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  validates_presence_of :name, :latitude, :longitude
  validates :name, uniqueness: { message: "Location name must be unique" }

  has_one :photo, as: :photographic
  accepts_nested_attributes_for :photo
  def the_photo
    photo.photo
  end
end