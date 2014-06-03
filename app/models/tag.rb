class Tag
  include Mongoid::Document
  validates :name, uniqueness: { message: "Tag name must be unique" }
  field :name, type: String 
  
end
