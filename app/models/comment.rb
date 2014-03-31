class Comment
  include Mongoid::Document

  field :body, type: String
  field :author, type: String
  field :state, type: String, default: "published"

  belongs_to :market, class_name: "Market", inverse_of: :comments

  def mark_as_reported
    self.update_attributes!(state: "reported")
  end

end