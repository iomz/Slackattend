module Slackattend
  module Core
    def config
      @config ||= YAML.load_file(File.expand_path('../../../config.yml', __FILE__))
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
