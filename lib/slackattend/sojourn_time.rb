module Slackattend
  class SojournTime < ActiveRecord::Base
    validates_presence_of :user

    def log(user, action, logrotate=false)
      # validates the user is leaving the room
      unless action == 'out'
        return nil
      end

      from = StatusLog.order("id desc").find_by_user(user).created_at.to_time
      to = Time.now
      date = to.to_date

      # midnight logrotate
      if logrotate
        date = from.to_date
        to = Time.parse("23:59", date)
      # unless logrotate and overnight
      elsif from.to_date < date
        from = Time.parse("00:00")
      end

      # sojour time in minute
      minute = (to - from).to_i

      create(:user => user, :date => date, :from => from, :to => to, :minute => minute)

      return nil
    end
  end
end
