class Photo
  include Mongoid::Document
  has_attachment :photo, accept: [:jpg, :png, :gif]
  accepts_nested_attributes_for :photo
  field :crop, type: Hash

  belongs_to :photographic, polymorphic: true

  scope :non_empty, lambda { where(:photo.exists => true) }

  def present?
    !photo.nil?
  end

  def empty?
    !present?
  end

  def is_owner?(user)
    photographic.user == user
    rescue
      false
  end

  def owner
    photographic.user
  end

  def user_id
    photographic.user.id
  rescue
    nil
  end

  def self.all
    self.non_empty
  end


  def self.icon
    "fa-camera"
  end
end