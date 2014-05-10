class Tag
  include Mongoid::Document
  validates :name, uniqueness: { message: "Tag name must be unique" }
  field :name, type: String 
  
  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :delete
  accepts_nested_attributes_for :photography
end
