class MarketDecorator < Draper::Decorator
  delegate_all

  def featured_photo(image_size)
    size = "#{image_size}x#{image_size}"
    h.cl_image_tag(market.featured.path,{ size: size, crop: :fit}) if market.featured?
  end 

  def show_link
    h.link_to("Show", h.user_market_path(market.user, market))
  end
  
  def edit_link
    if market_belongs_to_user?
      h.link_to("Edit", h.edit_user_market_path(market.user, market))
    end
  end

  def delete_link
    if market_belongs_to_user?
      h.link_to("Delete", h.user_market_path(market.user, market), :method => :delete)
    end
  end

  def like_link
    if market_does_not_belong_to_user?
      if user_does_not_like_market?
       h.link_to("Like", h.like_path(h.current_user, market))
      else
        h.link_to("Unlike", h.unlike_path(h.current_user, market))
      end
    end
  end

  private 

    def market_belongs_to_user?
      h.user_signed_in? && h.current_user == market.user
    end

    def market_does_not_belong_to_user?
      h.user_signed_in? && !(h.current_user == market.user)
    end

    def user_does_not_like_market?
       !h.current_user.favorites.include?(market)
    end

end

