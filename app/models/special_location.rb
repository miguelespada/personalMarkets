class SpecialLocation
  include Mongoid::Document
  field :name
  field :city, type: String
  field :address, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  field :important, type: Boolean
  validates_presence_of :name, :latitude, :longitude
  validates :name, uniqueness: { message: "Location name must be unique" }

  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :photography

  def self.icon
    "fa-map-marker"
  end

  def aspect_ratio
    2/1
  end
end