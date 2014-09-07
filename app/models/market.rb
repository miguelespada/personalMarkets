class Market
  
  include Mongoid::Document
  include Mongoid::Taggable
  disable_tags_index! 

  include Mongoid::Timestamps::Created

  include Tire::Model::Search
  include Tire::Model::Callbacks

  include Elasticsearch
  include Location
  include MarketDates
  include MarketStatus

  field :name, type: String
  field :description, type: String
  field :city, type: String
  field :address, type: String
  field :longitude, type: Float
  field :latitude, type: Float
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
  scope :last_published, lambda { where(state: "published").order_by(:publish_date.desc).limit(6) }
  scope :published, lambda {where(state: "published").order_by(:publish_date.desc)}
  scope :vim, lambda {where(pro: :true).order_by(:publish_date.desc)}
  scope :draft, lambda {where(state: "draft").order_by(:created_at.desc)}
  scope :archived, lambda {where(state: "archived").order_by(:publish_date.desc)}


  scope :with_category, lambda {|category| where(category: category)}

  after_create :create_public_id
  before_save :order_schedule

   def self.icon
    "fa-shopping-cart"
  end
  
  def create_coupon!(params)
      raise "Coupon already exists." if has_coupon?
      self.coupon = Coupon.new(params)
      save!
  end


  ####### MARKET FRIENDLY ID  ########
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


  ####### SEARCH MARKETS ########


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

  def date
    schedule.split(';').map{|d| d.split(',')[0]}.join(',') 
    rescue
  end

  def category_name
    category.slug
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
      sort do
        by :_geo_distance, 
          {lat_lon: location, 
            order: 'asc',   
            unit: 'km'} if !location.blank?
        by :date, {
          order: 'asc'
        }
      end 
      filter :terms, category: [category] if !category.blank?
      filter :geo_distance, lat_lon: location, distance: '3km' if !location.blank?
      filter :terms, state: ["published"]
      search_size = per_page
      from (page - 1) * search_size
      size search_size
    end
    results = search.results
    {:markets => results.collect{|result| find_by(id: result.to_hash[:id])}, :total => results.total}
  end

  def self.elasticsearch_count
    s = Tire.search 'markets', :search_type => 'count' do
      query do
        string 'name:*'
      end
    end
    s.results.total
  rescue
    -1
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






end
