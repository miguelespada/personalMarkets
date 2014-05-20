class Earning

  include Mongoid::Document

  field :amount, :type => Float

  belongs_to :user, class_name: "User"

  def self.for_user user_id
    self.where(user_id: user_id)
  end

end