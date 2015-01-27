module Slackattend
  class SojournTime < ActiveRecord::Base
    validates_presence_of :user
  end
end
