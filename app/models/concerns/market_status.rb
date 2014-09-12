module MarketStatus
  extend ActiveSupport::Concern


  module InstanceMethods
    def can_have_coupon?
      pro? || belongs_to_premium_user? && !archived?
    end

    def coupon_available?
      has_coupon? && can_have_coupon?
    end

    def has_coupon?
      coupon.filled?
      rescue
        false  
    end

    def coupon_initialized?
      coupon.initialized?
      rescue
        false
    end

    def photo_gallery_available?
      self.has_gallery?
    end

    def belongs_to_premium_user?
      self.user.is_premium?
    end

    def belongs_to_admin?
      self.user.admin?
    end

    def pro?
      return self.pro
    end

    def not_pro?
      return !(self.pro? || self.belongs_to_premium_user?)
    end

    def go_pro
      self.pro = true
      self.save!
    end

    def archive
      self.state = "archived"
      self.save!
    end

    def publish
      self.state = "published"
      self.publish_date ||= Time.now
      self.save!
    end

    def unpublish
      self.state = "draft"
      self.save!
    end

    def has_tags?
      !(self.tags.nil? || self.tags.empty?)
    end

    def has_location?
      self.latitude? && self.longitude?
    end

    def has_prices?
      (self.min_price? && self.min_price > 0) || (self.max_price? && self.max_price < 1000)
    end

    def has_slideshow?
      has_photos?
    end

    def has_url?
      self.url?
    end

    def has_social?
      self.social_link?
    end

    def path_to_social_link
      if !social_link.include?("http://") 
        "http://" + social_link
      else
        social_link
      end
    end

    def path_to_url
      if !url.include?("http://") 
        "http://" + url
      else
        url
      end
    end

    def has_name?
      self.name?
    end

    def has_been_published?
      !self.publish_date.nil?
    end

    def published?
      self.state == "published"
    end

    def ongoing?
      published? && running?
    end

    def archived?
      self.state == "archived"
    end

    def can_be_published?
      evaluation = MarketEvaluator.new(self).check_fields
      evaluation.valid? && self.state != "published"
    end

    def draft?
      self.state ||= "draft"
      self.state == "draft"
    end 

    def has_description?
      self.description?
    end

    def has_date?
      self.schedule?
    end
    
    def has_schedule?
      self.schedule?
    end

    def has_gallery?
      gallery != nil
    end

    def has_photos?
      has_gallery? && !gallery.empty?
    end

    def how_many_photos
      self.gallery.size
    end
  
    def staff_pick?
      favorited.each do |user|
        return true if user.admin?
      end
      false
    end

    def has_extra_photos?
      false
    end 
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end