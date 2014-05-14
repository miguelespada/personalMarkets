require "shorturl"

class MarketDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all 
  
  def link(text)
    link_to(text, market_path(market), :class => "show market-action")
  end 

  def owner
    user.email
  end

  def owner
    user.email
  end

  def category_name
    category.name
  end 

  def actions
      render partial: 'markets/shared/actions', locals: { market: self }
  end

  def badges
    if staff_pick?
      "staff_pick"
    elsif market.belongs_to_admin?
      "sample"
    elsif market.pro?
      "pro"
    end
  end

  def archive_link
    if can? :archive, market
      link_to "Archive", market_archive_path(market), { method: :post }
    end
  end

  def publish_link
    if can?(:publish, market) && market.state != "published"
      link_to "Publish", market_publish_path(market), { method: :post }
    end
  end

  def unpublish_link
    if (can? :unpublish, market) && market.state == "published"
      link_to "Unpublish", market_unpublish_path(market), { method: :post }
    end
  end

  def location
    if can? :see_location, Market
      render partial: 'markets/shared/location', locals: { market: market }
    end
  end

  def comment_form
    if can? :comment, market
      render partial: 'layouts/shared/comment_form', locals: { market: market }
    end
  end

  def coupon_section
    if market.coupon_available?
      render partial: "market_coupon", locals: { market: self }
    end
  end

  def buy_coupon_link
    if market.has_coupon?
      if can? :buy, market.coupon 
        link_to "Buy Coupon", coupon_path(market.coupon)
      end
    end
  end

  def photo_gallery_section
    if market.photo_gallery_available?
      render partial: "market_photo_gallery", locals: { market: self }
    end
  end


  def show_link
    link("Show")
  end
  
  def edit_link
    if can? :edit, market
      link_to("Edit", edit_user_market_path(market.user, market), 
        :class => "edit market-action")
    end
  end

  def delete_link
    if can? :delete, market
      link_to("Delete", user_market_path(market.user, market), method: :delete, 
        class: "delete market-action")
    end
  end

  def like_link
    if can? :like, market
      if !current_user.favorited?(market)
        link_to("Like", like_path(market), class: "like market-action")
      else  
        link_to("Unlike", unlike_path(market), class: "unlike market-action")
      end
    end
  rescue
  end

  def qr_code_link
    link_to("QR", user_market_path(market.user, market, :svg))
  end

  def pro_link
    link_to "Go PRO", market_make_pro_payment_path(market), class: "pro market-action" unless market.pro?
  end

  def statistics_link
    if can? :statistics, market
      link_to "Statistics", show_market_statistic_path(market), class: "pro market-action"
    end
  end

  def short_url
    ShortURL.shorten(market_url(market))
  end

  private 

    def market_belongs_to_user?
      user_signed_in? && current_user == market.user
    end

    def market_does_not_belong_to_user?
      user_signed_in? && !(current_user == market.user)
    end

    def user_does_not_like_market?
       !current_user.favorites.include?(market)
    end

end

