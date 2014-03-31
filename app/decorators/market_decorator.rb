class MarketDecorator < Draper::Decorator
  delegate_all

  def location
    h.render :partial => 'markets/shared/location', locals: { market: market }  if h.user_signed_in?
  end

  def comment_form
    if h.user_signed_in?
      h.render :partial => 'layouts/shared/comment_form', :locals => {:market => market}
    end
  end

  def delete_comment_link comment
    if comment_belogs_to_logged_user comment
      h.link_to "Delete", h.market_comment_path(market, comment), {:class => 'delete-comment-link', :method => :delete}
    end
  end

  def edit_comment_link comment
    if comment_belogs_to_logged_user comment
      h.link_to "Edit", "", {:id => "edit_link", :class => 'edit-comment-link', :data_market_id => market[:id], :data_comment_id => comment[:id]}
    end
  end

  def report_comment_link comment
    if h.user_signed_in?
      h.link_to "Report", h.report_comment_path(market, comment), { :class => 'report-comment-link', :method => :post }
    end
  end

  def featured_photo(image_size)
    size = "#{image_size}x#{image_size}"
    h.cl_image_tag(market.featured.path,{ size: size, crop: :fill}) if market.featured?
  end 

  def show_link
    h.link_to("Show", h.user_market_path(market.user, market), 
      :class => "show market-action")
  end
  
  def edit_link
    if market_belongs_to_user?
      h.link_to("Edit", h.edit_user_market_path(market.user, market), 
        :class => "edit market-action")
    end
  end

  def delete_link
    if market_belongs_to_user?
      h.link_to("Delete", h.user_market_path(market.user, market), :method => :delete, 
        :class => "delete market-action")
    end
  end

  def like_link
    if market_does_not_belong_to_user?
      if user_does_not_like_market?
        h.link_to("Like", h.like_path(h.current_user, market), 
          :class => "like market-action") 
      else
        h.link_to("Unlike", h.unlike_path(h.current_user, market), 
          :class => "like market-action")
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

    def comment_belogs_to_logged_user comment
      h.user_signed_in? &&  h.current_user.email == comment.author
    end

end

