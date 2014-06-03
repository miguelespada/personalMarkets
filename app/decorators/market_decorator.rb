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
  
  def hashtags 
   s = ""
    market.tags.split(/,/).each do |tag|
      s += tag.prepend('#')
      s += " "
    end
   s
  end

  def category_name
    category.name
  rescue
    "Uncategorized"
  end 

  def actions
      render partial: 'markets/shared/actions', locals: { market: self }
  end

  def actions_icon
      render partial: 'markets/shared/actions_icon', locals: { market: self }
  end

  def badges
    if passed?
      "passed ribbon-badge-passed"
    elsif staff_pick?
      "staff_pick ribbon-badge-staff_pick"
    elsif market.belongs_to_admin?
      "sample ribbon-badge-sample"
    elsif market.pro?
      "pro ribbon-badge-pro"
    elsif new_market?
      "new_market ribbon-badge-new"
    else
      "no_badge ribbon-badge-none"
    end
  end

  def archive_link
    if can? :archive, market
      link_to "Archive", market_archive_path(market), { method: :post }
    end
  end

  def publish_link
    if can?(:publish, market) && market.state != "published"
      link_to "Publish", market_publish_path(market), { method: :post, class: "publish market-action" }
    end
  end

  def unpublish_link
    if (can? :unpublish, market) && market.state == "published"
      link_to "Unpublish", market_unpublish_path(market), { method: :post, class: "unpublish market-action" }
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

  def edit_coupon_link
    if market.has_coupon?
     if can? :edit, coupon
      link_to("Edit", edit_user_market_path(market.user, market, :anchor => "form-market-coupon"), 
        :class => "edit edit-coupon market-action")
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
        class: "delete market-action", data: { confirm: 'Are you sure?'})
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
    if can? :edit, market
      link_to "Go PRO", market_make_pro_payment_path(market), class: "pro market-action" unless market.pro?
    end
  end

  def statistics_link
    if can? :statistics, market
      link_to "Statistics", show_market_statistic_path(market), class: "statistics market-action"
    end
  end

  def short_url
    ShortURL.shorten(market_url(market))
  end

  def is_today? 
    date.split(',').each do |day|
      return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i == 0
    end
    return false
  rescue
    false
  end
 
  def passed? 
    date.split(',').each do |day|
      return false if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i >= 0
    end
    return true
  rescue
    false
  end


  def is_this_week?
    return false if passed?
    return false if is_today?
    date.split(',').each do |day|
      return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i < 7
    end
    return false
  rescue
    false
  end

  def edit_link_icon
    if can? :edit, market
      link_to(content_tag(:i, "", :class => "fa fa-pencil"), edit_user_market_path(market.user, market), 
        :class => "edit-icon market-action")
    end
  end

  def delete_link_icon
    if can? :delete, market
      link_to(content_tag(:i, "", :class => "fa fa-trash-o"), user_market_path(market.user, market), method: :delete, 
        class: "delete-icon market-action")
    end
  end

  def archive_link_icon
    if can? :archive, market
      link_to content_tag(:i, "", :class => "fa fa-undo"), market_archive_path(market), { method: :post, class: "archive-icon market-action"  }
    end
  end

  def pro_link_icon
    if can? :edit, market
      link_to content_tag(:i, "", :class => "fa fa-plus-square"), market_make_pro_payment_path(market), class: "pro-icon market-action" unless market.pro?
    end
  end

  def statistics_link_icon
    if can? :statistics, market
      link_to content_tag(:i, "", :class => "fa fa-sitemap"), show_market_statistic_path(market), class: "statistics-icon market-action"
    end
  end

  def like_link_icon
    if can? :like, market
      if !current_user.favorited?(market)
        link_to(content_tag(:i, "", :class => "fa fa-heart"), like_path(market), class: "like-icon market-action")
      else  
        link_to(content_tag(:i, "", :class => "fa fa-heart-o"), unlike_path(market), class: "unlike-icon market-action")
      end
    end
  rescue
  end

  def market_date_highlight
    if is_today?
      content_tag(:i, "", :class => "fa fa-calendar") + "  Today"
    elsif is_this_week?
      content_tag(:i, "", :class => "fa fa-calendar") + "  This Week"
    end
  end

  def market_featured_photo_filtered(width, height)
    if passed?
      photo(featured, width, height, "grayscale")
    else
      photo(featured, width, height)
    end
  end

  def market_quality_section
    if can? :quality_section, market
      render partial: 'market_quality', locals: {market: market.decorate }
    end
  end

  def market_quality &block
    MarketEvaluator.new(market).evaluate_quality &block
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

