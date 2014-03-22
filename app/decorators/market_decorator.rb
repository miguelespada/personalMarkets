class MarketDecorator < Draper::Decorator
  delegate_all

  def featured_photo(image_size)
    size = "#{image_size}x#{image_size}"
    h.cl_image_tag(market.featured.path,{ size: size, crop: :fill}) if market.featured?
  end 

  def show_link
    h.link_to("Show", h.user_market_path(market.user, market), 
      :class => "market-action")
  end
  
  def edit_link
    if market_belongs_to_user?
      h.link_to("Edit", h.edit_user_market_path(market.user, market), 
        :class => "market-action")
    end
  end

  def delete_link
    if market_belongs_to_user?
      h.link_to("Delete", h.user_market_path(market.user, market), :method => :delete, 
        :class => "market-action")
    end
  end

  def like_link
    if market_does_not_belong_to_user?
      if user_does_not_like_market?
        h.link_to("Like", h.like_path(h.current_user, market), 
          :class => "market-action") 
      else
        h.link_to("Unlike", h.unlike_path(h.current_user, market), 
          :class => "market-action")
      end
    end
  end

  def qr_code_link
    h.link_to("QR", h.user_market_path(market.user, market, :svg))
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

