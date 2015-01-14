%w(
  yaml
).each { |lib| require lib }

#Thread.abort_on_exception = true
Encoding.default_external = Encoding.find('UTF-8')

%w(
  backend
  update_by_slack
  version 
).each { |name| require_dependency File.expand_path("../slackattend/#{name}", __FILE__) }

module Slackattend
  class Status < ActiveRecord::Base
  end
  
  class Member < ActiveRecord::Base
    validates :name, uniqueness: true
    validates :avatar, uniqueness: true
  end

  class Conf
    def self.[](key)
      ENV[key] || conf[key]
    end

    def self.[]=(key,value)
      conf[key] = value
    end

    def self.file
      @@file ||= File.dirname(__FILE__)+'/config.yml'
    end

    def self.file=(name)
      @@file = name
    end

    def self.save
      self.open 'w+' do |f|
        f.write self.to_yaml
      end
    end

    def self.to_yaml
      self.conf.to_yaml
    end
  end
end
