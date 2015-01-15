module Slackattend
  class Member < ActiveRecord::Base
    validates :name, uniqueness: true
    validates :avatar, uniqueness: true
  end
end
