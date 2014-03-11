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
end