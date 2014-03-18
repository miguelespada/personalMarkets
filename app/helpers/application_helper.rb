module ApplicationHelper
  def page_title(title)
    content_for :page_title, title
    "<h4>#{title}</h4>".html_safe
  end
end
