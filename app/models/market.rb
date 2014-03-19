
class Market
  include Mongoid::Document
  include Mongoid::Taggable
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Elasticsearch

  field :name, type: String
  field :description, type: String
  field :longitude, type: String
  field :latitude, type: String
  field :date, type: String
  has_attachment  :featured, accept: [:jpg, :png, :gif]

  belongs_to :category
  belongs_to :user, class_name: "User", inverse_of: :markets
  has_and_belongs_to_many :favorited, class_name: "User", inverse_of: :favorites

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

      query = query.blank? ? '*' : query
      from =  "19/03/2014"
      to = "21/03/2014"
      # Default elasticsearch format yyyymmdd
      #to = Date.strptime(to, "%d/%m/%Y").strftime("%Y%m%d") if !to.blank?
      #from = Date.strptime(from, "%d/%m/%Y").strftime("%Y%m%d") if !from.blank?

      the_query = lambda do |boolean|
         boolean.must {string query}
      #   boolean.must {string "date:[#{from} TO #{to}]" } if (!to.blank? && !from.blank?)
      end

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
      search.results.collect{|result| find(result.to_hash[:id])}
  end

end