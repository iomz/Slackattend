module Slackattend                                                                            
  class AttendanceCount < ActiveRecord::Base
    validates_presence_of :time
  end
end
