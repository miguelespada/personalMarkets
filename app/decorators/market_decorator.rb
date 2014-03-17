
class MarketDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end


  def show_link
    h.content_tag :td, h.link_to("Show", h.user_market_path(market.user, market))
  end
  
  def edit_link
    if is_user_market?
      h.content_tag :td, h.link_to("Edit", h.edit_user_market_path(market.user, market))
    end
  end

  def delete_link
    if is_user_market?
      h.content_tag :td, h.link_to("Delete", h.user_market_path(market.user, market), :method => :delete)
    end
  end

  def like_link
    if is_not_user_market?
      if user_likes_market?
        h.content_tag :td, h.link_to("Unlike", h.unlike_path(h.current_user, market))
      else
        h.content_tag :td, h.link_to("Like", h.like_path(h.current_user, market))
      end
    end
  end

  private 

    def is_user_market?
      h.user_signed_in? && h.current_user == market.user
    end

    def is_not_user_market?
      h.user_signed_in? && !(h.current_user == market.user)
    end

    def user_likes_market?
       h.current_user.favorites.include?(market)
    end

end

