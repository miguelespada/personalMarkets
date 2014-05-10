class Photo
  include Mongoid::Document
  has_attachment :photo, accept: [:jpg, :png, :gif]
  belongs_to :photographic, polymorphic: true
  field :crop, type: Hash
end