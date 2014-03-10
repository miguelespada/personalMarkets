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
end