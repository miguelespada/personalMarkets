module Location
  extend ActiveSupport::Concern

  module ClassMethods
    def with_location
      where(:latitude.nin => ["", nil], :longitude.nin => ["", nil])
    end
  end

  module InstanceMethods
    def to_marker(content, url, color)
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [longitude, latitude]
        },
        properties: {
          content: content,
          :'marker-color' => color,
          :'marker-symbol' => 'circle',
          :'marker-size' => 'medium',
          url: url
        }
      }
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
