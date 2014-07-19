class Category
  include Mongoid::Document
  include Mongoid::Slug

  slug :name

  validates :name, uniqueness: { message: "Category name must be unique" }
  field :name, type: String
  field :english, type: String
  field :style, type: String
  field :glyph, type: String
  field :order, type: Integer
  has_attachment  :glyph_img, accept: [:png]
  accepts_nested_attributes_for :glyph_img

  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :photography

  has_many :markets
  default_scope ->{ where(:name.ne => "").asc(:order)}
  
  def slug_candidates
    [
      :name
    ]
  end

  def destroy
    return false if markets_in_category?
    self.delete
  end

  def color
    "#FFFFFF"
  end

  def self.icon
    "fa-bars"
  end
  
  private

  def markets_in_category?
    self.markets.count > 0
  end
end
