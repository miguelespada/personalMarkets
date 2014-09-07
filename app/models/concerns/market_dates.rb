module MarketDates
  extend ActiveSupport::Concern


  module InstanceMethods
   
    def passed?
      return false if !self.has_date? 
      self.date.split(',').each do |day|
        return false if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i >= 0
      end
      return true
    rescue
      false
    end

    def started?
      return false if !self.has_date? 
      self.date.split(',').each do |day|
        return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i <= 0
      end
      return false
    rescue
      false
    end
    
    def running?
      started? && !passed?
    end

    def first_date
      Date.strptime(self.date.split(',')[0], "%d/%m/%Y")
    end

    def last_date
      Date.strptime(self.date.split(',')[-1], "%d/%m/%Y")
    end

    def in_date?(d)
       date.split(',').each do |day|
        return true if (Date.strptime(day, "%d/%m/%Y") - d).to_i == 0
      end
      return false
    end

    def is_today? 
      date.split(',').each do |day|
        return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i == 0
      end
      return false
    rescue
      false
    end

    def is_this_week?
      return false if passed?
      date.split(',').each do |day|
        return true if (Date.strptime(day, "%d/%m/%Y") - Date.today).to_i < 7
      end
      return false
    rescue
      false
    end

    def new_market?
      self.publish_date? && self.publish_date >= 1.day.ago 
    end

    def published_one_month_ago?
      self.publish_date? && self.publish_date >= 1.month.ago 
    end
    
    def append_schedule_to_empty_dates
      dates = self.schedule.split(';')
      dates.map{|d| d.split(',').count == 1? d + ",00:00,23:59": d}
      rescue
        []
    end

    def order_schedule 
      dates = append_schedule_to_empty_dates
      self.schedule = order_dates(dates).join(';')
    end

    def order_dates(dates)
      dates.sort! {|a, b| DateTime.strptime(a, "%d/%m/%Y") <=> DateTime.strptime(b, "%d/%m/%Y")}
    end
    
    def max_duration
      if belongs_to_premium_user?
        30
      else
        7
      end
    end

    def within_duration?(dates)
      dates = order_dates(dates.split(';'))
      return true if dates.count < 2
      (DateTime.parse(dates[-1]) - DateTime.parse(dates[0])).to_i <= max_duration
    end

    def serialize_schedule
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


  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
