
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

  def like_action
    if h.user_signed_in?
      unless h.current_user == market.user
        if h.current_user.favorites.include?(market)
          h.link_to "Unlike", h.unlike_path(h.current_user, market)
        else
          h.link_to "Like", h.like_path(h.current_user, market)
        end
      end
    end
  end
  
end

