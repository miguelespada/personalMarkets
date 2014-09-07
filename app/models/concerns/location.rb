module Location
  extend ActiveSupport::Concern

  module ClassMethods
    def with_location
      where(:latitude.nin => ["", nil], :longitude.nin => ["", nil])
    end
  end

  module InstanceMethods
    
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
