class Category
  include Mongoid::Document
  validates :name, uniqueness: {message: "Category name must be unique"}
  field :name, type: String 
  has_many :markets

  def destroy
    return false if self.markets.count > 0 || name == "Uncategorized"
    self.delete
  end
end
