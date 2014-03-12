class Market
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  field :name, type: String
  field :description, type: String
  has_attachment  :featured, accept: [:jpg, :png, :gif]

  belongs_to :category
  belongs_to :user

  validates_presence_of :name, :description, :user, :category

  def to_indexed_json
        {
          :id   => id,
          :name => name,
          :description => description,
          :category => category.name,
        }.to_json
  end

  def self.find_all(user = nil)
    if user
      user.markets.all
    else
      Market.all
    end
  end

  def self.reindex
     delete_index
     index_all
  end

  def self.delete_index
     Tire.index('markets').delete
  end

  def self.refresh_index
     Tire.index('markets').refresh
  end

  def self.index_all
    unless Tire.index('markets').exists?
      Tire.index 'markets' do
          delete
          create mappings: {
            market: {
              properties: {
                  category: { type: 'string', analyzer: 'keyword' }
              }
            }
          }
          import Market.all
          refresh
        end 
      end
  end

  def self.search(query, category)
    index_all
    query = query.blank? ? '*' : query

    s = Tire.search 'markets' do
      query do
        filtered do
          query {string query}
          unless category.blank?
            filter :terms, category: [category]
          end
        end
      end
    end
    markets = s.results.collect{|result| self.find(result.to_hash[:id])}
  end
end