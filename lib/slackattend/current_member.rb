module Slackattend
  class CurrentMember < ActiveRecord::Base
    validates_uniqueness_of :avatar_image_url, scope: :name
  end
end
