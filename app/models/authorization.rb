class Authorization
    
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    field :username, type: String

    belongs_to :user

    after_create :fetch_details

    def fetch_details
        self.send("fetch_details_from_#{self.provider.downcase}")
    end


    def fetch_details_from_facebook
    end

    def fetch_details_from_google_oauth2
    end

end