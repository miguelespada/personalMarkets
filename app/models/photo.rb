class Photo
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  
  has_attachment :photo, accept: [:jpg, :png, :gif]
  accepts_nested_attributes_for :photo


  field :crop, type: Hash
  field :owner_to_param, type: String
  
  belongs_to :photographic, polymorphic: true

  scope :non_empty, lambda { where(:photo.exists => true) }
  scope :for_user, ->(id) { where(:owner_to_param => id, :photo.exists => true).desc(:created_at)}

  before_update do |d|
    self.owner_to_param = photographic.user.to_param
  end

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
  rescue
    nil
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

  def aspect_ratio
    photographic.aspect_ratio
  rescue
    16.0/9
  end
end