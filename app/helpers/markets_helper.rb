module MarketsHelper
  def tooltip(market)
    div_for market, class: "market-tooltip" do
      render :partial => 'markets/shared/views/tooltip',
             :formats => [:html], 
             :locals => {:market => market.decorate}
    end
  end

  def save_and_publish_button(form, market)
    form.button :submit, I18n.t("market_form.update_and_publish_market").titleize, class: 'btn btn-info', id: 'save-and-publish-button'
  end

  def market_calendar(market)
    d0 = market.first_date.at_beginning_of_month.at_beginning_of_week
    d1 = market.first_date.end_of_month.at_end_of_week
    d2 = market.last_date.end_of_month.at_end_of_week
    
    s = content_tag :div, class: "month" do
       month_calendar(market, d0, d1, market.first_date.month, market.first_date.year)
    end
    
    if d1 != d2
      s += content_tag :div, class: "month" do
        month_calendar(market, d1.at_beginning_of_month.at_beginning_of_week, d2, market.last_date.month, market.last_date.year)
      end
    end
    s
  end

  def month_calendar(market, d0, d1, month, year) 
      content_tag(:span, (t("date.month_names")[month]).capitalize + " " + year.to_s, class: "month_title") + 
      (d0..d1).collect.with_index { |d, i| 
        if d.month == month
          content_tag(:span, d.day.to_s.rjust(2, "0"), class: "day market_#{market.in_date?(d)} passed_#{d.past?} today_#{d.today?}")
        else
          content_tag(:span, "---", class: "day passed_true")
        end
      }.join().html_safe
  end

  def market_dates(market)
    prevDate = nil
    s = ""
    market.human_readable_schedule.each do |day|
      if prevDate && prevDate == day["date"]
        s += ", " + day["from"] + " - " + day["to"]
      else 
        s += "</br>"  + format_date(day)
      end
      prevDate = day["date"]
    end
    s.html_safe
  end

  def format_date(day)
      (I18n.l day["date"], :format => :long).to_s + ", " + day["from"] + " - " + day["to"] 
  end

end