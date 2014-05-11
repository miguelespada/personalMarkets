class Photo
  include Mongoid::Document
  has_attachment :photo, accept: [:jpg, :png, :gif]
  accepts_nested_attributes_for :photo
  field :crop, type: Hash

  belongs_to :photographic, polymorphic: true

  def present?
    !photo.nil?
  end  
end