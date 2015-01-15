module Slackattend
  module Core
    def config
      @config ||= {}
    end

    def start
      YAML.load_file(File.expand_path('../../../config.yml', __FILE__)).each{ |k,v| config[k.to_sym] = v }
      setup
    end
  end

  extend Core
end

