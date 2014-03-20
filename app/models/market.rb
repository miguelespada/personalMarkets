class Market 
  include Mongoid::Document
  include Mongoid::Taggable
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Elasticsearch

  field :name, type: String
  field :description, type: String
  field :longitude, type: Float
  field :latitude, type: Float
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
          tags: tags
        }.to_json
  end

  def self.search(query, category)
      index_all
      query = query.blank? ? '*' : query

      search = Tire.search 'markets' do
        query do
          filtered do
            query {string query}
            unless category.blank?
              filter :terms, category: [category]
            end
          end
        end
      end
    search.results.collect{|result| find(result.to_hash[:id])}
  end

  def to_marker(content)
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [longitude, latitude]
        },
        properties: {
          content: content,
          :'marker-color' => '#00607d',
          :'marker-symbol' => 'circle',
          :'marker-size' => 'medium'
        }
      }
  end
end