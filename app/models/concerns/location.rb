module Location
  extend ActiveSupport::Concern

  module ClassMethods
    def with_location
      where(:latitude.nin => ["", nil], :longitude.nin => ["", nil])
    end
  end

  module InstanceMethods
    def to_marker(content)
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [longitude, latitude]
        },
        properties: {
          content: content,
          :'marker-color' => '#00607d',
          :'marker-symbol' => 'circle',
          :'marker-size' => 'medium'
        }
      }
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
