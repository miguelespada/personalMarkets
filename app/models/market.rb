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
  field :address, type: String
  field :longitude, type: Float
  field :latitude, type: Float
  field :date, type: String
  has_attachment  :featured, accept: [:jpg, :png, :gif]

  belongs_to :category
  belongs_to :user, class_name: "User", inverse_of: :markets
  has_and_belongs_to_many :favorited, class_name: "User", inverse_of: :favorites
  has_many :comments, class_name: "Comment", inverse_of: :market

  validates_presence_of :name, :description, :user, :category

  def like(user)
    favorited << user
  end

  def unlike(user)
    favorited.delete(user)
  end

  def to_indexed_json
        { id: id,
          name: name,
          description: description,
          category: category.name,
          tags: tags,
          date: format_date
        }.to_json
  end

  def format_date
     Date.strptime(date, "%d/%m/%Y").strftime("%Y%m%d") if date.present?
  end

  def self.search(query, category, from = "",  to = "" )
      index_all
      return [] if Market.count == 0 

      query = query.blank? ? '*' : query
      range = format_range_query(from, to)

      the_query = lambda do |boolean|
         boolean.must {string query}
         boolean.must {string "date:[#{range}]" } if !range.blank?
      end

      puts category
      
      search = Tire.search 'markets' do
        query do
          boolean &the_query
          filtered do
            unless category.blank?
              filter :terms, category: [category]
            end
          end
        end
      end
      values = search.results.collect{|result| find(result.to_hash[:id])}
  end
  
  def self.format_range_query(from, to)
      # Default elasticsearch format yyyymmdd
     begin
      range = Date.strptime(from, "%d/%m/%Y").strftime("%Y%m%d")
      range += " TO "
      begin
        range += Date.strptime(to, "%d/%m/%Y").strftime("%Y%m%d")
      rescue
        range += "99991231"
      end
    rescue
    end
      range ||= ""
  end

  def created_one_month_ago?
    self.created_at <= 1.month.ago
  end
end
