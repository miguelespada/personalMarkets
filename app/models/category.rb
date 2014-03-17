class Category
  include Mongoid::Document

  validates :name, uniqueness: { message: "Category name must be unique" }

  field :name, type: String 

  has_many :markets

  def destroy
    return false if markets_in_category? || undefined_category_name?
    self.delete
  end

  private

  def markets_in_category?
    self.markets.count > 0
  end

  def undefined_category_name?
    name == "Uncategorized"
  end
end
