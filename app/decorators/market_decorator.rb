
class MarketDecorator < Draper::Decorator
  delegate_all

  def show_link
    h.content_tag :td, h.link_to("Show", h.user_market_path(market.user, market))
  end
  
  def edit_link
    if market_belongs_to_user?
      h.content_tag :td, h.link_to("Edit", h.edit_user_market_path(market.user, market))
    end
  end

  def delete_link
    if market_belongs_to_user?
      h.content_tag :td, h.link_to("Delete", h.user_market_path(market.user, market), :method => :delete)
    end
  end

  def like_link
    if market_does_not_belong_to_user?
      if user_does_not_like_market?
        h.content_tag :td, h.link_to("Like", h.like_path(h.current_user, market))
      else
        h.content_tag :td, h.link_to("Unlike", h.unlike_path(h.current_user, market))
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

