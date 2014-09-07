class Contact

  include Mongoid::Document

  field :email, :type => String, :default => ""
  field :description, type: String
  field :name, type: String
  field :subject, type: String

end
