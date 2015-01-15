module Slackattend
  class StatusLog < ActiveRecord::Base
    validates_presence_of :action
  end
end
