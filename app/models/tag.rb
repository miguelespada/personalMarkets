class Tag
  include Mongoid::Document
  validates :name, uniqueness: { message: "Tag name must be unique" }
  field :name, type: String 
  
  def has_markets?
     Market.tagged_with(name).count > 0
  end
end
