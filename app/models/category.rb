class Category
  include Mongoid::Document

  validates :name, uniqueness: { message: "Category name must be unique" }
  field :name, type: String 
  has_attachment :photo, accept: [:jpg, :png, :gif]

  has_many :markets

  def destroy
    return false if markets_in_category?
    self.delete
  end

  private

  def markets_in_category?
    self.markets.count > 0
  end
end
