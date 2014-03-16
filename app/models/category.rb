class Category
  include Mongoid::Document
  validates :name, uniqueness: {message: "Category name must be unique"}
  field :name, type: String 
  has_many :markets
end
