class Market
  include Mongoid::Document
  include Mongoid::Elasticsearch
  
  field :name, type: String
  field :description, type: String
  has_attachment  :featured, accept: [:jpg, :png, :gif]

  belongs_to :category
  belongs_to :user

  validates_presence_of :name, :description, :user, :category

  elasticsearch! 

  def self.find_all(user = nil)
    if user
      user.markets.all
    else
      Market.all
    end
  end

  def self.search(user, query, category_id)
    if !Market.es.index.exists? 
      Market.es.index_all
    end
    if query.blank?
      query = {body: {query: {match_all: { }}}}
    end
    Market.es.search(query)

  end
end