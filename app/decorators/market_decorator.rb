require "shorturl"


class MarketDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all 
  def link(text)
    link_to(text, market_path(market), :class => "show market-action")
  end 

  def owner
    link_to user.name, user_path(user)
  end
  
  def hashtags 
   s = ""
    market.tags.split(/,/).each do |tag|
      s += tag.prepend('#').tr(' ', '_').camelize
      s += " "
    end
   s
  end

  def category_name
    intl_name(category)
  rescue
    "Uncategorized"
  end 

  def human_readable_schedule
    dates = []
    schedule.split(';').each do |day|
      date = Date.strptime(day, "%d/%m/%Y,%H:%M")
      dateTime = DateTime.strptime(day, "%d/%m/%Y,%H:%M")
      dates << {"date" => date, 
                "passed" => dateTime < Time.now,
                "to_string" => day, 
                "day" => day.split(',')[0],
                "from" => day.split(',')[1], 
                "to" => day.split(',')[2]}
    end
    dates
  rescue
    []
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
  rescue
    "no_badge ribbon-badge-none"
  end

  def address_and_city
    if market.address.present? && market.city.present?
      market.address + ", " + market.city 
    else
      t(:Market_location_is_not_provided)
    end
  end

  def location
    render partial: 'markets/shared/utils/location', locals: { market: market }
  end

  def coupon_section
    render partial: "coupons/views/full_view", locals: { market: self }
  end

  def photo_slideshow_section
    if market.photo_gallery_available?
      render partial: "markets/shared/utils/photo_slideshow", locals: { market: self }
    end
  end
  
  def photo_gallery_section
    if market.photo_gallery_available?
      render partial: "markets/shared/utils/photo_gallery", locals: { market: self }
    end
  end

  def qr_code_link
    link_to("QR", user_market_path(market.user, market, :svg))
  end

  def short_url
    ShortURL.shorten(market_url(market))
  end

  def like_class
    if can? :like, market
      if !current_user.favorited?(market)
        "like-badge-color"
      else  
        "unlike-badge-color"
      end
    end
  rescue
  end

  def market_date_highlight
    if is_today?
      content_tag(:i, "", :class => "fa fa-calendar") + "  Today"
    elsif is_this_week?
      content_tag(:i, "", :class => "fa fa-calendar") + "  This Week"
    elsif market.date.split(',').count > 2 
      content_tag(:i, "", :class => "fa fa-calendar") + " " + market.date.split(',').first + "..." + market.date.split(',').last
    else
      content_tag(:i, "", :class => "fa fa-calendar") + " " + market.date
    end
  rescue
  end

  def market_like_count
    content_tag(:i, "", :class => "fa fa-heart-o") + " " + content_tag(:span, market.favorited.count, :class => "like-counter")
  end


  def market_featured_photo_filtered(width)
    if passed?
      photo(featured, width, nil, {:effect => "grayscale"})
    else
      photo(featured, width, nil)
    end
  end

  def market_photo_round_thumb(width, height)
    photo(featured, width, height, {:radius => "max"})
  end

  def formatted_market_name
    if market.pro?
      content_tag(:span, "VIM", :class => "pro-indicator") + " " + market.name
    else
      market.name
    end
  end

  def market_quality_section
    if can? :quality_section, market
      render partial: 'markets/shared/utils/quality', locals: {market: market.decorate}
    end
  end

  def market_quality &block
    MarketEvaluator.new(market).evaluate_quality &block
  end


  ##### SOCIAL SHARING #####

  def twitter_text
    "http://twitter.com/home?status=@PersonalMarkets, #{short_url}, %23#{name.tr(' ', '_').camelize}: #{description} #{hashtags.gsub('#', '%23')}"
  end

  def pinterest_text
    "http://pinterest.com/pin/create/link/?url=#{short_url}&media=#{cloudinary_url(featured.photo.path)}&description=Do We Market: #{name}, #{description} #{hashtags.gsub('#', '%23')}"
  end

  def google_text
    "https://plus.google.com/share?url=#{short_url}"
  end

  def facebook_text
    "https://www.facebook.com/sharer/sharer.php?s=100"
  end

  ##### LINKS #####

  def actions
    render partial: 'markets/shared/utils/actions', locals: { market: self }
  end
  
  def social_links
    return if market.archived?
    render partial: 'markets/shared/utils/social_links', locals: { market: self }
  end 

  def statistics_link
    if can? :statistics, market
      link_to content_tag(:i, content_tag(:span, " Stats", :class => "hidden-xs"), :class => "fa fa-sitemap"), show_market_statistic_path(market), class: "statistics-icon market-action market-action-icon btn btn-default btn-market-action-bar"
    end
  end

  def like_link
    return if market.archived?
    if can? :like, market
      if !current_user.favorited?(market)
        link_to(content_tag(:i,  content_tag(:span, " Like", :class => "hidden-xs"), :class => "fa fa-heart"), like_path(market), class: "like-icon market-action btn btn-default market-action-icon btn-market-action-bar")
      else  
        link_to(content_tag(:i, content_tag(:span, " Unlike", :class => "hidden-xs") , :class => "fa fa-heart-o"), unlike_path(market), class: "unlike-icon market-action btn btn-default market-action-icon btn-market-action-bar")
      end
    end
  rescue
  end

  def like_badge_link
    return if market.archived?
    if can? :like, market
      if !current_user.favorited?(market)
        link_to(content_tag(:i, "", :class => "fa fa-heart-o"), like_path(market), class: "like-icon")
      else  
        link_to(content_tag(:i, "", :class => "fa fa-heart"), unlike_path(market), class: "unlike-icon")
      end
    end
  rescue
  end

  def discard_button
    link_to content_tag(:i, content_tag(:span, " Discard", :class => "hidden-xs"), 
      :class => "fa fa-undo", :title => "Discard", rel: 'tooltip'), self, 
      :class=>  "btn btn-default", 
      :id=>"discard" 
  end

  def edit_link
    return if market.archived?
    if can? :edit, market 
      link_to(content_tag(:i, content_tag(:span, " Edit", :class => "hidden-xs"), :class => "fa fa-pencil"), edit_user_market_path(market.user, market), 
        :class => "edit-icon market-action market-action-icon btn btn-default btn-market-action-bar")
    end
  end

  def poster_link
    return if market.archived?
    link_to(content_tag(:i, content_tag(:span, " Poster", :class => "hidden-xs"), :class => "fa fa-print"), market_poster_path(market), { method: :get, class: "btn btn-default poster poster-icon market-action  btn-market-action-bar" })
  end

  def print_link
    link_to(content_tag(:i, " Print", :class => "fa fa-print"), market_poster_path(market, :format => "pdf"), { method: :get, class: "btn btn-default" })
  end

  def delete_link
    return if cannot? :delete, market 
    return if market.archived?
    return if market.has_been_published? && !current_user.has_role?(:admin)
    link_to(content_tag(:i, content_tag(:span, " Delete", :class => "hidden-xs"), :class => "fa fa-trash-o"), user_market_path(market.user, market), method: :delete, 
        class: "delete-icon market-action market-action-icon btn btn-default btn-market-action-bar")
  rescue
  end

  def archive_link 
    return if market.archived?
    return if !market.has_been_published?
    if can? :archive, market
      link_to content_tag(:i, content_tag(:span, " Archive", :class => "hidden-xs"), :class => "fa fa-undo"), market_archive_path(market), { method: :post, class: "archive-icon market-action btn btn-default market-action-icon btn-market-action-bar"  }
    end
  end

  def buy_coupon_link
    if can? :buy, market.coupon
      link_to "Buy Coupon", buy_coupon_form_path(market.coupon), {class: "btn btn-default coupon-action-button"}
    else
      "<h1> Register or login to buy coupons </h1>".html_safe
    end 
  end

  def pro_link
    return if market.archived?
    if can? :force_make_pro, market 
      link_to content_tag(:i, content_tag(:span, " Free VIM", :class => "hidden-xs"), :class => "fa fa-plus-square"), market_force_make_pro_path(market), {method: :post, class: "force-pro-icon market-action  btn btn-default market-action-icon btn-market-action-bar" } unless market.pro?
    elsif can? :edit, market
      link_to content_tag(:i, content_tag(:span, " Go VIM", :class => "hidden-xs"), :class => "fa fa-plus-square"), market_make_pro_payment_path(market), class: "pro-icon market-action market-action-icon btn btn-default btn-market-action-bar" unless market.pro?
    end
  end

  def publicable?
    return can?(:publish, market) && market.can_be_published? && !market.archived?
  end


  def publish_link
    if publicable?
      link_to t(:Publish), market_publish_path(market), { method: :post, class: "btn btn-success publish market-action" }
    end
  end


  def publish_icon_link
    if publicable?
      link_to image_tag("upload.png", size: "120"), market_publish_path(market), { method: :post}
    end
  end

  def unpublish_link
    return if market.archived?
    if (can? :unpublish, market) && market.state == "published"
      link_to "Unpublish", market_unpublish_path(market), { method: :post, class: "btn btn-warning unpublish market-action" }
    end
  end


  def direct_edit_link(anchor)
    return if market.archived?
    if can? :edit, market
      link_to("(edit)", edit_user_market_path(market.user, market, :anchor => anchor))
    end
  end

  def transactions_link
    if market.has_coupon?
     if can? :edit, market
      link_to(content_tag(:i, content_tag(:span, " Coupons", :class => "hidden-xs"), :class => "fa fa-ticket"), sold_coupons_by_market_path(market), 
        :class => "transactions-icon market-action btn btn-default market-action-icon btn-market-action-bar")
      end
    end
  end

  def invite_to_add_coupon
    if can? :edit, market
      if market.can_have_coupon? 
        "Remember to create a coupon to offer extra services in your market."
      else 
        "Upgrade your market to offer coupons."
      end
    else
      "This market do not have available coupons"
    end
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

