class SlideshowImage
  include Mongoid::Document
  
  has_one :photography, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :photography

  def self.icon
    "fa-film"
  end

  def aspect_ratio
    10/3.0
  end

end