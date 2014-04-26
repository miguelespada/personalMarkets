class Market
  
  include Mongoid::Document
  include Mongoid::Taggable
  include Mongoid::Slug
  include Mongoid::Timestamps::Created

  include Tire::Model::Search
  include Tire::Model::Callbacks

  include Elasticsearch
  include Location

  field :name, type: String
  field :description, type: String
  field :city, type: String
  field :address, type: String
  field :longitude, type: Float
  field :latitude, type: Float
  field :date, type: String
  field :state, type: String

  belongs_to :category
  belongs_to :user, class_name: "User", inverse_of: :markets
  has_and_belongs_to_many :favorited, class_name: "User", inverse_of: :favorites
  has_many :comments, class_name: "Comment", inverse_of: :market
  has_one :coupon, class_name: "Coupon", inverse_of: :market
  
  accepts_nested_attributes_for :coupon

  slug :name, history: false, scope: :user

  has_attachment :featured, accept: [:jpg, :png, :gif]

  validates_presence_of :name, :description, :user, :category

  def delete_featured_image
    self.featured = nil
    self.save!
  end

  def can_be_published
    self.state != "published"
  end

  def archive
    self.state = "archived"
    self.save
  end

  def publish
    self.state = "published"
    self.save
  end

  def like(user)
    favorited << user
  end

  def unlike(user)
    favorited.delete(user)
  end

  def has_coupon?
    coupon != nil
  end

  def create_coupon!(params)
    raise "Coupon already exists." if has_coupon?
    self.coupon = Coupon.new(params)
    save!
  end

  def to_indexed_json
        { id: id,
          name: name,
          description: description,
          category: category.name,
          city: city,
          tags: tags.split(/,/),
          date: format_date,
          state: state,
          lat_lon: lat_lon
        }.to_json
  end

  def lat_lon
    if latitude.nil? or longitude.nil?
      "0,0"
    else
      [latitude, longitude].join(',')
    end
  end

  def format_date
    if date.present?
      dates = date.split(/,/)
      dates.collect{|d| Date.strptime(d, "%d/%m/%Y").strftime("%Y%m%d")}
    end
  end

  def self.search(params)
    index_all
    return [] if Market.count == 0 

    query = params[:query].blank? ? '*' : params[:query]
    range = format_range_query(params[:from], params[:to])
    city = params[:city] 
    category = params[:category]
    location = format_location(params[:latitude], params[:longitude])

    elasticQuery = lambda do |boolean|
      boolean.must {string query}
      boolean.must {string "city:#{city}" } if !city.blank?
      boolean.must {string "date:[#{range}]" } if !range.blank?
    end

    search = Tire.search 'markets' do
      query do
        boolean &elasticQuery
      end
      sort { by :date, 'asc' }
      filter :terms, category: [category] if !category.blank?
      filter :geo_distance, lat_lon: location, distance: '5km' if !location.blank?
      filter :terms, state: ["published"] 
    end
    search.results.collect{|result| find(result.to_hash[:id])}
  end

  def self.format_location(lat, lon)
    [lat, lon].join(',') if !lat.blank? 
  end 

  def self.format_range_query(from, to)
      # Default elasticsearch format yyyymmdd
    range = Date.strptime(from, "%d/%m/%Y").strftime("%Y%m%d")
    range += " TO "
    begin
      range += Date.strptime(to, "%d/%m/%Y").strftime("%Y%m%d")
    rescue
      range += "99991231"
    end
    rescue
      range ||= ""
  end

  def created_one_month_ago?
    self.created_at? && self.created_at <= 1.month.ago
  end
end
