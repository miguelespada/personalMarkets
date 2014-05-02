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

  def archive_link
    if can? :archive, market
      link_to "Archive", market_archive_path(market), { method: :post }
    end
  end

  def publish_link
    if can? :publish, market
      link_to "Publish", market_publish_path(market), { method: :post }
    end
  end

  def delete_photo_link
    if can? :delete_image, market
      content_tag :div, class: "market-featured-photo-actions" do
        link_to "Delete", delete_image_path(market), { method: :post }
      end
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

  def buy_coupon_link
    if market.has_coupon?
      if can? :buy, market.coupon 
        link_to "Buy Coupon", coupon_path(market.coupon)
      end
    end
  end

  def delete_comment_link comment
    if can? :destroy, comment
      link_options = { class: 'delete-comment-link', method: :delete }
      link_to "Delete", market_comment_path(market, comment), link_options
    end
  end

  def edit_comment_link comment
    if can? :edit, comment
      link_options = {
        id: "edit_link",
        class: 'edit-comment-link',
        data_market_id: market[:id],
        data_comment_id: comment[:id]
      }
      link_to "Edit", "", link_options
    end
  end

  def report_comment_link comment
    if can? :report, Comment
      link_to "Report", report_comment_path(market, comment),
        { :class => 'report-comment-link', :method => :post }
    end
  end

  def featured_photo(width, height = nil)
    heihgt ||= width
    size = "#{width}x#{height}"
    image_options = { size: size, crop: :fill }
    if market.featured?
      cl_image_tag(market.featured.path, image_options) 
    else
      image_tag "default-image.png", image_options
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
      link = link_to("Like", like_path(current_user, market), class: "like market-action")
    end
    if can? :unlike, market
      link = link_to("Unlike", unlike_path(current_user, market), class: "unlike market-action")
    end
    link
  end

  def qr_code_link
    link_to("QR", user_market_path(market.user, market, :svg))
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

