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
      return false if is_today?
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

    def order_schedule
      dates = self.schedule.split(';')
      sorted = dates.sort! {|a, b| DateTime.strptime(a, "%d/%m/%Y,%H:%M") <=> DateTime.strptime(b, "%d/%m/%Y,%H:%M")}.join(';')
    rescue
    end
    
    def max_duration
      if belongs_to_premium_user?
        30
      else
        7
      end
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
