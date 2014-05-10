class Photo
  include Mongoid::Document
  has_attachment :photo, accept: [:jpg, :png, :gif]
  field :crop, type: Hash

  belongs_to :photographic, polymorphic: true
  
end