class Category
  include Mongoid::Document

  validates :name, uniqueness: { message: "Category name must be unique" }
  validates :english, uniqueness: { message: "Category name must be unique" }
  field :name, type: String
  field :english, type: String
  field :style, type: String
  field :glyph, type: String
  field :color, type: String
  
  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :photography

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
