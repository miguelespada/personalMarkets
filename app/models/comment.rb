class Comment
  include Mongoid::Document

  field :body, type: String

  belongs_to :market, class_name: "Market", inverse_of: :comments

end