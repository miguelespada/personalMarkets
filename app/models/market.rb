class Market
  
  include Mongoid::Document
  include Mongoid::Taggable
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
  field :pro, type: Boolean
  field :publish_date, type: DateTime
  field :public_id, type: String
  field :schedule, type: String
  field :url, type: String
  field :social_link, type: String
  field :min_price, type: Float
  field :max_price, type: Float

  validates_uniqueness_of :public_id

  belongs_to :category
  belongs_to :user, class_name: "User", inverse_of: :markets
  has_and_belongs_to_many :favorited, class_name: "User", inverse_of: :favorites
  has_and_belongs_to_many :recommended, class_name: "Wish", inverse_of: :recommended

  has_one :coupon, class_name: "Coupon", inverse_of: :market, dependent: :destroy
  accepts_nested_attributes_for :coupon

  has_one :featured, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :featured
 
  has_one :gallery, class_name: "Gallery", autobuild: true, dependent: :destroy, inverse_of: :market
  accepts_nested_attributes_for :gallery

  validates_presence_of :name, :user

  scope :last_pro_published, lambda {where(state: "published").where(pro: :true).order_by(:published_date.desc).limit(6) }
  scope :last_published, lambda { where(state: "published").order_by(:published_date.desc).limit(6) }
  scope :published, lambda {where(state: "published").order_by(:date.asc)}
  scope :with_category, lambda {|category| where(category: category)}

  after_create :create_public_id
  after_save :collect_cities 
  after_update :order_schedule

  def coupon_available?
    self.has_coupon? && (self.pro? || self.belongs_to_premium_user?)
  end

  def photo_gallery_available?
    self.has_gallery?
  end

  def publish_available?
    !self.has_coupon? || self.pro? || self.belongs_to_premium_user?
  end

  def belongs_to_premium_user?
    self.user.is_premium?
  end

  def belongs_to_admin?
    self.user.admin?
  end

  def pro?
    return self.pro
  end

  def not_pro?
    return !(self.pro? || self.belongs_to_premium_user?)
  end

  def go_pro
    self.pro = true
    self.save!
  end

  def archive
    self.state = "archived"
    self.save!
  end

  def publish
    self.state = "published"
    self.publish_date ||= Time.now
    self.save!
  end

  def unpublish
    self.state = "draft"
    self.save!
  end

  def like(user)
    favorited << user
  end

  def unlike(user)
    favorited.delete(user)
  end

  def has_tags?
    !(self.tags.nil? || self.tags.empty?)
  end

  def has_location?
    self.latitude? && self.longitude?
  end

  def has_prices?
    (self.min_price? && self.min_price > 0) || (self.max_price? && self.max_price < 1000)
  end

  def has_url?
    self.url?
  end

  def has_name?
    self.name?
  end

  def has_been_published?
    !self.publish_date.nil?
  end

  def published?
    self.state == "published"
  end

  def archived?
    self.state == "archived"
  end

  def can_be_published?
    evaluation = MarketEvaluator.new(self).check_fields
    evaluation.valid? && self.state != "published"
  end

  def draft?
    self.state ||= "draft"
    self.state == "draft"
  end 

  def has_description?
    self.description?
  end

  def has_date?
    self.date?
  end

  def passed?
    return false if !self.has_date? 
    self.date.split(',').each do |day|
      return false if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i >= 0
    end
    return true
  rescue
    false
  end

   def started?
    return false if !self.has_date? 
    self.date.split(',').each do |day|
      return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i <= 0
    end
    return false
  rescue
    false
  end

  def is_today? 
    date.split(',').each do |day|
      return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i == 0
    end
    return false
  rescue
    false
  end

  def is_this_week?
    return false if passed?
    return false if is_today?
    date.split(',').each do |day|
      return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i < 7
    end
    return false
  rescue
    false
  end


  def has_schedule?
    self.schedule?
  end

  def has_coupon?
    coupon != nil && coupon.description!= nil && coupon.available != nil && coupon.price != nil
  end

  def has_gallery?
    gallery != nil
  end

  def has_photos?
    has_gallery? && !gallery.empty?
  end

  def how_many_photos
    self.gallery.size
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
        category: category_name,
        city: city,
        tags: tags.split(/,/),
        date: format_date,
        state: state,
        lat_lon: lat_lon
      }.to_json
  end

  def category_name
    category.name
  rescue
    ""
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

  def self.search(params, page = 1, per_page = 6)
    index_all
    return {:markets => [], :total => 0} if Market.count == 0 

    query = params[:query].blank? ? '*' : params[:query].gsub(/[\!]/, '')
    page ||= 1
    page = 1 if page < 1
    range = format_range_query(params[:from], params[:to])
    category = params[:category]
    location = format_location(params[:latitude], params[:longitude])
    distance = params[:distance] 

    elasticQuery = lambda do |boolean|
      boolean.must {string query, default_operator: "AND"}
      boolean.must {string "date:[#{range}]" } if !range.blank?
    end

    search = Tire.search 'markets' do
      query do
        boolean &elasticQuery
      end
      if location.blank?
        sort { by :date, 'asc' } 
      else
        sort do
          by :_geo_distance, 
            {lat_lon: location, 
              order: 'asc',   
              unit: 'km'}
        end 
      end
      filter :terms, category: [category] if !category.blank?
      filter :terms, state: ["published"]
      search_size = per_page
      from (page - 1) * search_size
      size search_size
    end
    
    results = search.results
    {:markets => results.collect{|result| find_by(id: result.to_hash[:id])}, :total => results.total}
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

  def staff_pick?
    favorited.each do |user|
      return true if user.admin?
    end
    false
  end

  def new_market?
    self.created_at? && self.created_at >= 1.day.ago
  end

  def to_param
    self.public_id
  end

  def create_public_id
    name_ord = self.name.codepoints.inject(:+)
    creation = self.created_at.to_i
    self.public_id ||= (creation + name_ord).to_s(32)
    self.save!
  end

  def self.find id
    find_by(public_id: id)
  end

  def collect_cities
    @@cities ||= [""]
    @@cities.append(city.split(',')[0]) if !city.blank?
    @@cities = @@cities.compact.uniq
  end

  def self.cities
    @@cities ||= all.collect{|market| market.city.split(',')[0] if !market.city.blank?}.compact.uniq.prepend("")
  end

   def self.reset_cities
    @@cities = nil 
  end

  def order_schedule
    dates = self.schedule.split(';')
    sorted = dates.sort! {|a, b| DateTime.strptime(a, "%d/%m/%Y,%H:%M") <=> DateTime.strptime(b, "%d/%m/%Y,%H:%M")}.join(';')
    if sorted != self.schedule
      self.update_attribute(:schedule, sorted)
    end
  rescue
  end
end
