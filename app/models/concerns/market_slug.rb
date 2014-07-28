module MarketDates
  extend ActiveSupport::Concern


  module InstanceMethods
    def to_param
      self.public_id
    end

    def create_public_id
      name_ord = self.name.codepoints.inject(:+)
      creation = self.created_at.to_i
      self.public_id ||= (creation + name_ord).to_s(32)
      self.save!
    end


  end


  module ClassMethods
    def find id
      find_by(public_id: id)
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end